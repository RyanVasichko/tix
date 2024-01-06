FactoryBot.define do
  factory :user_role, class: User::Role.to_s do
    name { "Role #{Faker::Number.unique.number(digits: 2)}" }
    hold_seats { false }
    release_seats { false }
    manage_customers { false }
    manage_admins { false }

    trait :superadmin do
      name { "superadmin" }
      hold_seats { true }
      release_seats { true }
      manage_customers { true }
      manage_admins { true }
    end
  end
end
