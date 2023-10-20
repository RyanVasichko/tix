FactoryBot.define do
  factory :order_shipping_address, class: 'Order::ShippingAddress' do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    association :address
  end
end
