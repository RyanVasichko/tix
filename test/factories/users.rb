FactoryBot.define do
  factory :user do
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

    transient do
      shopping_cart_merch_count { 0 }
      reserved_seats_count { 0 }
    end

    after(:build) do |user, evaluator|
      if user.shopping_cart.empty?
        user.shopping_cart = FactoryBot.build(
          :shopping_cart,
          merch_count: evaluator.shopping_cart_merch_count,
          reserved_seats_count: evaluator.reserved_seats_count,
          user: user)
      end
    end

    factory :guest, class: 'User::Guest' do
    end

    factory :customer, class: 'User::Customer' do
      registered
      with_password
    end

    factory :admin, class: 'User::Admin' do
      registered
      with_password
    end
  end
end
