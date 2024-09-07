module FactoryRunners
  class GeneralAdmissionShows

    def run
      puts "- #{upcoming_general_admission_shows_count} upcoming general admission shows"
      bar = ProgressBar.new(upcoming_general_admission_shows_count, :bar, :counter, :percentage)
      upcoming_general_admission_shows_count.times do
        FactoryBot.create \
          :general_admission_show,
          with_existing_artist: true,
          sections_count: 2,
          with_existing_venue: true

        bar.increment!
        Faker::Commerce.unique.clear
      end

      puts "- #{past_general_admission_shows_count} past general admission shows"
      bar = ProgressBar.new(past_general_admission_shows_count, :bar, :counter, :percentage)
      past_general_admission_shows_count.times do
        FactoryBot.create \
          :general_admission_show,
          :past,
          with_existing_artist: true,
          sections_count: 2,
          with_existing_venue: true

        bar.increment!
        Faker::Commerce.unique.clear
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
