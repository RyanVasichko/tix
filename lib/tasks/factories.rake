namespace :db do
  namespace :factories do
    task load: [:environment, "db:drop", "db:prepare"] do
      artist_image_blobs = [
        ActiveStorage::Blob.create_and_upload!(
          io: File.open(Rails.root.join("test", "fixtures", "files", "radiohead.jpg")),
          filename: "radiohead.jpg",
          content_type: "image/jpeg"
        ),
        ActiveStorage::Blob.create_and_upload!(
          io: File.open(Rails.root.join("test", "fixtures", "files", "lcd_soundsystem.webp")),
          filename: "lcd_soundsystem.webp",
          content_type: "image/webp"
        )
      ]

      artists_count = ENV.fetch("ARTISTS_COUNT") { 20 }.to_i
      general_admission_shows_count = ENV.fetch("GENERAL_ADMISSION_SHOWS_COUNT") { 20 }.to_i
      reserved_seating_shows_count = ENV.fetch("RESERVED_SEATING_SHOWS_COUNT") { 20 }.to_i
      venue_seating_charts_count = ENV.fetch("VENUE_SEATING_CHARTS_COUNT") { 2 }.to_i
      venues_count = ENV.fetch("VENUES_COUNT") { 3 }.to_i
      merch_count = ENV.fetch("MERCH_COUNT") { 5 }.to_i
      puts "Creating #{artists_count} artists, #{general_admission_shows_count} general admission shows, " +
             "#{reserved_seating_shows_count} reserved seating shows, #{merch_count} merch, " +
             "#{venues_count} venues, and #{venue_seating_charts_count} seating charts per venue"

      artists = (1..artists_count).map { FactoryBot.create(:artist, image_blob: artist_image_blobs.sample) }
      puts "Artists created"

      venues = (1..venues_count).map { FactoryBot.create(:venue) }
      puts "Venues created"

      venue_layout_blob = ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join("test", "fixtures", "files", "seating_chart.bmp")),
        filename: "seating_chart.bmp",
        content_type: "image/bmp"
      )

      venues.each do |venue|
        venue_seating_charts_count.times do
          FactoryBot.create(
            :seating_chart,
            sections_count: 4,
            section_seats_count: 90,
            venue_layout_blob: venue_layout_blob,
            venue: venue)
          Faker::SeatingChart.unique.clear
        end
      end
      puts "Seating charts created"

      reserved_seating_shows_count.times do
        FactoryBot.create(
          :reserved_seating_show,
          artist: artists.sample,
          sections_count: 4,
          section_seats_count: 90,
          venue: venues.sample,
          venue_layout_blob: venue_layout_blob)
        Faker::SeatingChart.unique.clear
      end

      general_admission_shows_count.times do
        FactoryBot.create(
          :general_admission_show,
          artist: artists.sample,
          sections_count: 2,
          section_seats_count: 100,
          venue: venues.sample)
      end
      puts "Shows created"

      merch_image_blob = ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join("test/fixtures/files/bbq_sauce.png")),
        filename: "bbq_sauce.png",
        content_type: "image/png")
      FactoryBot.create_list(:merch, merch_count, image_blob: merch_image_blob)
      puts "Merch created"
    end
  end
end

Rake::Task["db:factories:load"].enhance(["tmp:clear"])
