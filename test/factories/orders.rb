FactoryBot.define do
  trait :order do
    order_total { Faker::Commerce.price }
    association :shipping_address, factory: :order_shipping_address

    transient do
      reserved_seating_tickets_count { 1 }
      merch_count { 1 }
      general_admission_tickets_count { 1 }
      with_existing_shows { false }
      with_existing_user { false }
      with_existing_merch { false }
    end

    after(:build) do |order, evaluator|
      build_show = evaluator.reserved_seating_tickets_count.positive? && order.tickets.empty?
      seats = []
      if build_show && evaluator.with_existing_shows
        seats = Show::Seat.not_sold.order("RANDOM()").limit(evaluator.reserved_seating_tickets_count)
        raise "Not enough seats to build order" if seats.count < evaluator.reserved_seating_tickets_count
      else
        show = FactoryBot.build(:reserved_seating_show)
        seats = show.sections.map(&:seats).flatten.sample(evaluator.reserved_seating_tickets_count)
        seats.each { |seat| seat.show = show }
      end
      order.tickets << Order::ReservedSeatingTicket.build_for_seats(seats)

      if evaluator.general_admission_tickets_count.positive?
        sections = if evaluator.with_existing_shows
                     Show::Sections::GeneralAdmission.order("RANDOM()").limit(evaluator.general_admission_tickets_count)
        else
                     FactoryBot.create_list(:general_admission_show_section, evaluator.general_admission_tickets_count)
        end

        order.tickets << sections.map do |section|
          Order::GeneralAdmissionTicket.new(show: section.show,
                                            show_section: section,
                                            quantity: 1)
                                       .tap(&:calculate_pricing)
        end
      end

      order.tickets.each { |ticket| ticket.order = order }

      show = order.tickets.first&.show
      if show.present?
        random_seconds_in_show_on_sale_range = rand(show.front_end_on_sale_at.to_i - show.front_end_off_sale_at.to_i)
        random_date_in_show_on_sale_range = show.front_end_on_sale_at + random_seconds_in_show_on_sale_range.seconds

        order.created_at = random_seconds_in_show_on_sale_range
      end

      if evaluator.merch_count.positive? && order.merch.empty?
        merch_to_add = if evaluator.with_existing_merch
                         Merch.order("RANDOM()").limit(evaluator.merch_count)
        else
                         FactoryBot.create_list(:merch, evaluator.merch_count)
        end

        order.merch << merch_to_add.map do |merch|
          Order::Merch.new(merch: merch,
                           quantity: 1,
                           unit_price: merch.price,
                           total_price: merch.price * 1,
                           option: merch.options.sample,
                           option_label: merch.option_label)
        end
      end

      order.calculate_order_total

      order.payment = FactoryBot.build(:order_payment, order: order, amount_in_cents: order.total_in_cents) unless order.payment.present?
    end
  end

  factory :guest_order, class: Order.to_s, traits: [:order] do
    association :orderer, factory: :guest_orderer
  end

  factory :customer_order, class: Order.to_s, traits: [:order] do
    orderer { nil }

    after(:build) do |order, evaluator|
      order.orderer ||= FactoryBot.build(:customer) unless evaluator.with_existing_user
      order.orderer ||= User::Customer.order("RANDOM()").first if evaluator.with_existing_user
    end
  end
end
