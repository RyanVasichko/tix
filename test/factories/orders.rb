FactoryBot.define do
  trait :order do
    balance_paid { total_price }
    total_price { Faker::Commerce.price }
    total_fees { Faker::Commerce.price(range: 0..5.0) }
    order_number { nil }
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
      FactoryBot.create(:merch_shipping_rate, weight: 0.25) unless Merch::ShippingRate.any?

      build_show = evaluator.reserved_seating_tickets_count.positive? && order.purchases.filter(&:ticket?).empty?
      seats = []
      if build_show && evaluator.with_existing_shows
        seats = Show::Seat.not_sold.random(evaluator.reserved_seating_tickets_count)
        raise "Not enough seats to build order" if seats.count < evaluator.reserved_seating_tickets_count
      else
        show = FactoryBot.build(:reserved_seating_show)
        seats = show.sections.map(&:seats).flatten.sample(evaluator.reserved_seating_tickets_count)
        seats.each { |seat| seat.show = show }
      end
      order.purchases += seats.map do |seat|
        FactoryBot.build(:order_reserved_seating_ticket_purchase, purchaseable: seat.ticket || seat.build_ticket, quantity: 1, order: order)
      end

      if evaluator.general_admission_tickets_count.positive?
        sections = if evaluator.with_existing_shows
                     Show::Sections::GeneralAdmission.random(evaluator.general_admission_tickets_count)
                   else
                     FactoryBot.create_list(:general_admission_show_section, evaluator.general_admission_tickets_count)
                   end

        order.purchases << sections.map do |section|
          ticket = Tickets::GeneralAdmission.new(show_section: section)
          FactoryBot.build(:order_general_admission_ticket_purchase, purchaseable: ticket, quantity: 1, order: order)
        end
      end

      show = order.purchases.filter(&:ticket?).first&.purchaseable&.show
      if show.present?
        random_seconds_in_show_on_sale_range = rand(show.front_end_on_sale_at.to_i - show.front_end_off_sale_at.to_i)
        random_date_in_show_on_sale_range = show.front_end_on_sale_at + random_seconds_in_show_on_sale_range.seconds

        order.created_at = random_seconds_in_show_on_sale_range
      end

      if evaluator.merch_count.positive? && order.purchases.merch.empty?
        merch_to_add = if evaluator.with_existing_merch
                         Merch.all.sample(evaluator.merch_count)
                       else
                         FactoryBot.create_list(:merch, evaluator.merch_count)
                       end

        order.purchases << merch_to_add.map do |merch|
          FactoryBot.build(:order_merch_purchase, purchaseable: merch, quantity: 1, order: order)
        end
      end

      order.calculate_order_totals

      order.payment = FactoryBot.build(:order_payment, order: order, amount_in_cents: order.balance_paid_in_cents) unless order.payment.present?
    end
  end

  factory :guest_order, class: Order.to_s, traits: [:order] do
    association :orderer, factory: :guest_orderer
  end

  factory :customer_order, class: Order.to_s, traits: [:order] do
    orderer { nil }

    after(:build) do |order, evaluator|
      order.orderer ||= FactoryBot.build(:customer) unless evaluator.with_existing_user
      order.orderer ||= Users::Customer.random(1).first if evaluator.with_existing_user
    end
  end
end
