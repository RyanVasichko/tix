require_relative "has_venue_layout"
require_relative "forking"

module FactoryRunners
  class ReservedSeatingShows
    include HasVenueLayout
    include Forking

    def run
      with_forking do
        upcoming_reserved_seating_shows_count.times do |t|
          FactoryBot.create \
            :reserved_seating_show,
            with_existing_artist: true,
            sections_count: 4,
            section_tickets_count: 90,
            with_existing_venue: true,
            venue_layout: VENUE_LAYOUT_BLOB

          Faker::SeatingChart.unique.clear
          Faker::Commerce.unique.clear
        end

        puts "- #{upcoming_reserved_seating_shows_count} upcoming reserved seating shows"
      end

      with_forking do
        past_reserved_seating_shows_count.times do |t|
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
        end

        puts "- #{upcoming_reserved_seating_shows_count} past reserved seating shows"
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
