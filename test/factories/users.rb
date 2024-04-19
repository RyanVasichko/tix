FactoryBot.define do
  trait :user do
    transient do
      shopping_cart_merch_count { 0 }
      reserved_seats_count { 0 }
      general_admission_tickets_count { 0 }
      orders_count { 0 }
    end

    shopping_cart do |evaluator|
      # TODO: Probably make this in after(:build)
      FactoryBot.build(:shopping_cart,
                       merch_count: evaluator.shopping_cart_merch_count,
                       reserved_seats_count: evaluator.reserved_seats_count,
                       general_admission_tickets_count: evaluator.general_admission_tickets_count,
                       user: nil)
    end

    after(:build) do |user, evaluator|
      if evaluator.orders_count&.positive?
        orders = []
        case user
        when Users::Customer
          user.orders << FactoryBot.build_list(:customer_order, evaluator.orders_count, orderer: user)
          orders = user.orders
        when Users::Guest
          orders = FactoryBot.build_list(:guest_order, evaluator.orders_count)
        else
          raise "Unknown user type: #{user.class}"
        end
      end
    end
  end

  trait :registered do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.cell_phone }
    email { "#{first_name}.#{last_name}@#{Faker::Internet.domain_name}" }
  end

  trait :with_password do
    password { "Radiohead" }
    password_confirmation { "Radiohead" }
  end

  factory :guest, traits: %i[user], class: "Users::Guest" do
  end

  factory :customer, traits: %i[user registered with_password], class: "Users::Customer" do
  end

  factory :admin, traits: %i[user registered with_password], class: "Users::Admin" do
    after(:build) do |admin|
      admin.role ||= User::Role.find_by_name("superadmin") || FactoryBot.build(:user_role, :superadmin)
    end
  end
end
