FactoryBot.define do
  factory :merch do
    price { Faker::Commerce.price(range: 0..1000.0, as_string: true) }
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    active { true }
    options { Array.new(rand(1..5)) { Faker::Color.unique.color_name } }
    option_label { Faker::Commerce.material }
    created_at { Faker::Date.between(from: 1.year.ago, to: Date.today) }
    updated_at { Faker::Date.between(from: created_at, to: Date.today) }

    transient do
      categories_count { 0 }
      categories { [] }
    end

    trait :inactive do
      active { false }
    end

    after(:build) do |merch, evaluator|
      if evaluator.categories.any?
        merch.categories = evaluator.categories
      else
        merch.categories = build_list(:merch_category, evaluator.categories_count)
      end

      unless merch.image.attached?
        merch.image.attach(
          io: File.open(Rails.root.join("test/fixtures/files/coffee.jpg")),
          filename: "coffee.jpg",
          content_type: "image/jpeg")
      end
    end
  end
end