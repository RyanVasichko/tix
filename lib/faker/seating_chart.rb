module Faker
  class SeatingChart < Base
    class << self
      def seat_positions
        position_string = fetch("faker.seating_chart.seat_positions")
        position_string.split(",").map(&:to_i)
      end
    end
  end
end
