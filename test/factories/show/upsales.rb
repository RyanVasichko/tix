FactoryBot.define do
  factory :show_upsale, class: "Show::Upsale" do
    name { Faker::Commerce.unique.product_name }
    description { Faker::Lorem.sentence }
    price { Faker::Commerce.price(range: 0..100.0) }
    quantity { Faker::Number.between(from: 1, to: 100) }
    active { true }
    association :show, factory: :reserved_seating_show
  end
end
