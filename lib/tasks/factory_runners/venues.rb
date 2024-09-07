require_relative "has_venue_layout"

module FactoryRunners
  class Venues
    include HasVenueLayout

    def run
      puts "- #{venues_count} venues"
      puts "- #{venue_seating_charts_count} seating charts per venue"

      bar = ProgressBar.new(venues_count, :bar, :counter, :percentage)
      venues_count.times do
        venue = FactoryBot.create(:venue)
        create_seating_charts_for_venue(venue)
        bar.increment!
      end
    end

    private

    def create_seating_charts_for_venue(venue)
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

    def venues_count
      ENV.fetch("VENUES_COUNT", 3).to_i
    end

    def venue_seating_charts_count
      ENV.fetch("VENUE_SEATING_CHARTS_COUNT", 2).to_i
    end
  end
end
