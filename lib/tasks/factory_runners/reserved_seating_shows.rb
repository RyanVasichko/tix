require_relative "has_venue_layout"

module FactoryRunners
  class ReservedSeatingShows
    include HasVenueLayout

    def run
      puts "- #{upcoming_reserved_seating_shows_count} upcoming reserved seating shows"
      bar = ProgressBar.new(upcoming_reserved_seating_shows_count, :bar, :counter, :percentage)
      upcoming_reserved_seating_shows_count.times do
        FactoryBot.create \
          :reserved_seating_show,
          with_existing_artist: true,
          sections_count: 4,
          section_tickets_count: 90,
          with_existing_venue: true,
          venue_layout: VENUE_LAYOUT_BLOB

        Faker::SeatingChart.unique.clear
        Faker::Commerce.unique.clear
        bar.increment!
      end

      puts "- #{past_reserved_seating_shows_count} past reserved seating shows"
      bar = ProgressBar.new(past_reserved_seating_shows_count, :bar, :counter, :percentage)
      past_reserved_seating_shows_count.times do
        FactoryBot.create \
          :reserved_seating_show,
          :past,
          with_existing_artist: true,
          sections_count: 4,
          section_tickets_count: 90,
          with_existing_venue: true,
          venue_layout: VENUE_LAYOUT_BLOB

        Faker::SeatingChart.unique.clear
        Faker::Commerce.unique.clear
        bar.increment!
      end
    end

    private

    def upcoming_reserved_seating_shows_count
      ENV.fetch("UPCOMING_RESERVED_SEATING_SHOWS_COUNT", 20).to_i
    end

    def past_reserved_seating_shows_count
      ENV.fetch("PAST_RESERVED_SEATING_SHOWS_COUNT", 20).to_i
    end
  end
end
