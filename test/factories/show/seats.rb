FactoryBot.define do
  factory :show_seat, class: 'Show::Seat' do
    x { Faker::Number.between(from: 1, to: 100) }
    y { Faker::Number.between(from: 1, to: 100) }
    seat_number { Faker::Number.between(from: 1, to: 100).to_i }
    table_number { Faker::Number.between(from: 1, to: 100).to_i }
    association :section, factory: :show_section
  end
end