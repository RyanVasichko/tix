FactoryBot.define do
  factory :show_upsale, class: 'Show::Upsale' do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    price { Faker::Commerce.price(range: 0..100.0) }
    quantity { Faker::Number.between(from: 1, to: 100) }
    active { true }
    association :show

    trait :skip_show do
      association :show, strategy: :null
    end
  end
end