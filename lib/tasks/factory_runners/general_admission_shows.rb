require_relative "forking"

module FactoryRunners
  class GeneralAdmissionShows
    include Forking

    def run
      with_forking do
        FactoryBot.create_list \
          :general_admission_show,
          upcoming_general_admission_shows_count,
          with_existing_artist: true,
          sections_count: 2,
          with_existing_venue: true
        puts "- #{upcoming_general_admission_shows_count} upcoming general admission shows"
      end

      with_forking do
        FactoryBot.create_list \
          :general_admission_show,
          past_general_admission_shows_count,
          :past,
          with_existing_artist: true,
          sections_count: 2,
          with_existing_venue: true
        puts "- #{past_general_admission_shows_count} past general admission shows"
      end
    end

    private

    def upcoming_general_admission_shows_count
      ENV.fetch("UPCOMING_GENERAL_ADMISSION_SHOWS_COUNT", 20).to_i
    end

    def past_general_admission_shows_count
      ENV.fetch("PAST_GENERAL_ADMISSION_SHOWS_COUNT", 20).to_i
    end
  end
end
