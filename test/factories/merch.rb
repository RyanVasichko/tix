FactoryBot.define do
  factory :merch do
    price { Faker::Commerce.price(range: 0..1000.0, as_string: true) }
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    active { [true, false].sample }
    options { Array.new(rand(1..5)) { Faker::Commerce.color } }
    option_label { Faker::Commerce.material }
    created_at { Faker::Date.between(from: 1.year.ago, to: Date.today) }
    updated_at { Faker::Date.between(from: created_at, to: Date.today) }

    transient do
      categories_count { 0 }
      categories { [] }
    end

    after(:build) do |merch, evaluator|
      if evaluator.categories.any?
        merch.merch_categories = evaluator.categories
      else
        merch.merch_categories = build_list(:merch_category, rand(1..3))
      end
    end
  end
end