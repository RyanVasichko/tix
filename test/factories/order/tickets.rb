FactoryBot.define do
  factory :order_ticket, class: 'Order::Ticket' do
    association :seat, factory: :show_seat
    show { seat.show }
    convenience_fees { nil }
    venue_commission { nil }
    ticket_price { nil }
    total_price { nil }


    after :build do |ticket|
      FactoryBot.build(:order, tickets: [ticket]) unless ticket.order.present?
      ticket.set_pricing_from_seat unless ticket.total_price.present?
    end
  end
end
