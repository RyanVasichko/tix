FactoryBot.define do
  factory :order_merch, class: "Order::Merch" do
    association :merch
    quantity { Faker::Number.between(from: 1, to: 10) }
    unit_price { Faker::Commerce.price }
    total_price { unit_price * quantity }
    option { Faker::Lorem.word }
    option_label { Faker::Lorem.sentence }

    transient do
      order_type { :customer_order }
    end

    after :build do |merch_order, evaluator|
      merch_order.order = FactoryBot.build(evaluator.order_type) unless merch_order.order.present?
    end
  end
end
