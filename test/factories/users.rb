FactoryBot.define do
  trait :user do
    transient do
      shopping_cart_merch_count { 0 }
      reserved_seats_count { 0 }
    end

    shopping_cart do |evaluator|
      FactoryBot.build(
        :shopping_cart,
        merch_count: evaluator.shopping_cart_merch_count,
        reserved_seats_count: evaluator.reserved_seats_count,
        user: nil)
    end
  end

  trait :registered do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.cell_phone }
    email { Faker::Internet.unique.email }
  end

  trait :with_password do
    password { "password" }
    password_confirmation { "password" }
  end

  factory :guest, traits: %i[user], class: 'User::Guest' do
  end

  factory :customer, traits: %i[user registered with_password], class: 'User::Customer' do
    registered
    with_password
  end

  factory :admin, traits: %i[user registered with_password], class: 'User::Admin' do
    registered
    with_password
  end
end
