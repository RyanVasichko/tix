FactoryBot.define do
  factory :show_seat, class: 'Show::Seat' do
    x { Faker::Number.between(from: 1, to: 100) }
    y { Faker::Number.between(from: 1, to: 100) }
    seat_number { Faker::Number.between(from: 1, to: 100).to_i }
    table_number { Faker::Number.between(from: 1, to: 100).to_i }
    association :section, factory: :show_section

    trait :skip_section do
      association :section, strategy: :null
    end
  end
end