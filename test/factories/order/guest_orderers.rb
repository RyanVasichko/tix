FactoryBot.define do
  factory :guest_orderer, class: "Order::GuestOrderer" do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.phone_number }
    shopper_uuid { SecureRandom.uuid }
  end
end
