FactoryBot.define do
  trait :order do
    order_total { Faker::Commerce.price }
    association :shipping_address, factory: :order_shipping_address

    transient do
      tickets_count { 1 }
      with_existing_shows { false }
      with_existing_user { false }
    end

    after(:build) do |order, evaluator|
      build_show = evaluator.tickets_count.positive? && order.tickets.empty?
      seats = []

      if build_show && evaluator.with_existing_shows
        seats = Show::Seat.not_sold.order("RANDOM()").limit(evaluator.tickets_count)
        raise "Not enough seats to build order" if seats.count < evaluator.tickets_count
      else
        show = FactoryBot.build(:reserved_seating_show)
        seats = show.sections.map(&:seats).flatten.sample(evaluator.tickets_count)
        seats.each { |seat| seat.show = show }
      end

      order.tickets << Order::ReservedSeatingTicket.build_for_seats(seats)
      order.tickets.each { |ticket| ticket.order = order }

      show = order.tickets.first&.show
      if show.present?
        random_seconds_in_show_on_sale_range = rand(show.front_end_on_sale_at.to_i - show.front_end_off_sale_at.to_i)
        random_date_in_show_on_sale_range = show.front_end_on_sale_at + random_seconds_in_show_on_sale_range.seconds

        order.created_at = random_seconds_in_show_on_sale_range
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
