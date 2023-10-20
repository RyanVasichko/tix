FactoryBot.define do
  factory :order_merch, class: 'Order::Merch' do
    association :merch
    association :order
    quantity { Faker::Number.between(from: 1, to: 10) }
    unit_price { Faker::Commerce.price }
    total_price { unit_price * quantity }
    option { Faker::Lorem.word }
    option_label { Faker::Lorem.sentence }
  end
end
