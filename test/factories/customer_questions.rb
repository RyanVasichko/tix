FactoryBot.define do
  factory :customer_question do
    question { Faker::Lorem.sentence }
    active { true }

    trait :inactive do
      active { false }
    end
  end
end
