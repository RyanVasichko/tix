FactoryBot.define do
  factory :merch_shipping_charge, class: Merch::ShippingCharge.to_s do
    weight { 5 }
    price { 9.99 }
  end
end
