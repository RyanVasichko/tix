require_relative "has_venue_layout"

module FactoryRunners
  class Venues
    include HasVenueLayout
    def run
      venues = (1..venues_count).map { FactoryBot.create(:venue) }
      puts "- #{venues_count} venues"

      venues.each do |venue|
        venue_seating_charts_count.times do
          FactoryBot.create(
            :seating_chart,
            sections_count: 4,
            section_seats_count: 90,
            venue_layout_blob: VENUE_LAYOUT_BLOB,
            venue: venue)
          Faker::SeatingChart.unique.clear
        end
      end
      puts "- #{venue_seating_charts_count} seating charts per venue"

      venues
    end

    private

    def venues_count
      ENV.fetch("VENUES_COUNT", 3).to_i
    end

    def venue_seating_charts_count
      ENV.fetch("VENUE_SEATING_CHARTS_COUNT", 2).to_i
    end
  end
end
