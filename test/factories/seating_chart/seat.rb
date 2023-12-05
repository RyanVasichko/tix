require Rails.root.join("lib", "faker", "seating_chart")

FactoryBot.define do
  factory :seating_chart_seat, class: "SeatingChart::Seat" do
    seat_number { Faker::Number.between(from: 1, to: 100).to_s }
    table_number { Faker::Number.between(from: 1, to: 100).to_s }
    association :section, factory: :seating_chart_section

    after(:build) do |seat|
      seat_position = Faker::SeatingChart.unique.seat_positions
      seat.x = seat_position[0]
      seat.y = seat_position[1]
    end
  end
end
