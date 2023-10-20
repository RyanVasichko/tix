FactoryBot.define do
  factory :order_ticket, class: 'Order::Ticket' do
    association :seat, factory: :show_seat
    show { seat.show }
    price { Faker::Commerce.price }

    after :build do |ticket|
      FactoryBot.build(:order, tickets: [ticket]) unless ticket.order.present?
    end
  end
end
