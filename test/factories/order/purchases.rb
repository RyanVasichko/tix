FactoryBot.define do
  trait :order_purchase do
    association :order, factory: :customer_order
    quantity { Faker::Number.between(from: 1, to: 3) }
    options { { Faker::Lorem.word => Faker::Lorem.word } }

    after(:build) do |purchase|
      purchase.calculate_pricing
    end
  end

  factory :order_merch_purchase, class: Order::Purchase, traits: [:order_purchase] do
    association :purchaseable, factory: :merch
  end

  factory :order_general_admission_ticket_purchase, class: Order::Purchase, traits: [:order_purchase] do
    association :purchaseable, factory: :general_admission_ticket
  end

  factory :order_reserved_seating_ticket_purchase, class: Order::Purchase, traits: [:order_purchase] do
    association :purchaseable, factory: :reserved_seating_ticket
  end
end
