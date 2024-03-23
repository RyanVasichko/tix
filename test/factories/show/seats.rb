require Rails.root.join("lib", "faker", "seating_chart")

FactoryBot.define do
  factory :show_seat, class: "Show::Seat" do
    seat_number { Faker::Number.between(from: 1, to: 100).to_i }
    table_number { Faker::Number.between(from: 1, to: 100).to_i }

    after(:build) do |seat|
      seat.ticket ||= build(:reserved_seating_ticket, seat: seat)

      seat_position = Faker::SeatingChart.unique.seat_positions
      seat.x = seat_position[0]
      seat.y = seat_position[1]
    end
  end
end
