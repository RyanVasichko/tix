FactoryBot.define do
  factory :seating_chart_seat, class: 'SeatingChart::Seat' do
    x { Faker::Number.between(from: 100, to: 1000) }
    y { Faker::Number.between(from: 100, to: 1000) }
    seat_number { Faker::Number.between(from: 1, to: 100).to_s }
    table_number { Faker::Number.between(from: 1, to: 100).to_s }
    association :section, factory: :seating_chart_section

    trait :skip_section do
      association :section, strategy: :null
    end
  end
end