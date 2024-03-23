FactoryBot.define do
  factory :merch_shipping_rate, class: Merch::ShippingRate do
    weight { 5 }
    price { 9.99 }
  end
end
