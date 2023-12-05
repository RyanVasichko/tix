FactoryBot.define do
  trait :order_ticket do
    show { seat.show }
    convenience_fees { nil }
    venue_commission { nil }
    ticket_price { nil }
    total_price { nil }
  end

  factory :reserved_seating_order_ticket, traits: [:order_ticket], class: 'Order::ReservedSeatingTicket' do
    association :seat, factory: :show_seat

    after :build do |ticket|
      FactoryBot.build(:order, tickets: [ticket]) unless ticket.order.present?
      ticket.set_pricing_from_seat unless ticket.total_price.present?
    end
  end
end
