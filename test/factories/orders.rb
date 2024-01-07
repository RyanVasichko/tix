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
      order.payment = FactoryBot.build(:order_payment, order: order) unless order.payment.present?

      build_show = evaluator.tickets_count.positive? && order.tickets.empty?
      seats = []

      if build_show && evaluator.with_existing_shows
        seats = Show::Seat.all.sample(evaluator.tickets_count)
      else
        show = FactoryBot.build(:reserved_seating_show)
        seats = show.sections.map(&:seats).flatten.sample(evaluator.tickets_count)
        seats.each { |seat| seat.show = show }
      end

      order.tickets << Order::ReservedSeatingTicket.build_for_seats(seats)
      order.tickets.each { |ticket| ticket.order = order }
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
