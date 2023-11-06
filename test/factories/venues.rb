FactoryBot.define do
  factory :venue do
    name { "#{Faker::Company.name} Arena" }
    active { true }
  end
end
