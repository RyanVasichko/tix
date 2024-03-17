FactoryBot.define do
  factory :merch_category, class: Merch::Category do
    name { Faker::Commerce.unique.department }
    created_at { Faker::Date.between(from: 1.year.ago, to: Date.today) }
    updated_at { Faker::Date.between(from: created_at, to: Date.today) }
  end
end
