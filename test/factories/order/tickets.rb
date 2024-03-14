FactoryBot.define do
  trait :order_ticket do
    show { seat.show }
    convenience_fees { nil }
    venue_commission { nil }
    ticket_price { nil }
    total_price { nil }

    transient do
      order_type { :customer_order }
    end
  end

  factory :reserved_seating_order_ticket, traits: [:order_ticket], class: "Order::Tickets::ReservedSeating" do
    association :seat, factory: :show_seat

    after :build do |ticket, evaluator|
      ticket.set_pricing_from_seat unless ticket.total_price.present?
      ticket.order = FactoryBot.build(evaluator.order_type, tickets: [ticket]) unless ticket.order.present?
    end
  end
end
