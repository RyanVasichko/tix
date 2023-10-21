FactoryBot.define do
  factory :order do
    association :user, factory: :customer
    order_total { Faker::Commerce.price }
    association :shipping_address, factory: :order_shipping_address

    transient do
      tickets_count { 1 }
    end

    after(:build) do |order, evaluator|
      order.payment = FactoryBot.build(:order_payment, order: order) unless order.payment.present?

      if evaluator.tickets_count > 0 && order.tickets.empty?
        show = FactoryBot.build(:show)
        seats = show.sections.map { |s| s.seats }.flatten.sample(evaluator.tickets_count)
        seats.each { |seat| seat.show = show }
        order.tickets.build_for_seats(seats)
        order.tickets.each { |ticket| ticket.order = order }
      end
    end
  end
end