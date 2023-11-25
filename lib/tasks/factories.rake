require Rails.root.join("lib", "tasks", "factories_helpers", "null_queue_adapter")

namespace :db do
  namespace :factories do
    task load: [:environment, "db:schema:load"] do
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
      shows_count = ENV.fetch("SHOWS_COUNT") { 20 }.to_i
      venue_seating_charts_count = ENV.fetch("VENUE_SEATING_CHARTS_COUNT") { 2 }.to_i
      venues_count = ENV.fetch("VENUES_COUNT") { 3 }.to_i
      puts "Creating #{artists_count} artists, #{shows_count} shows, #{venues_count} venues, and #{venue_seating_charts_count} seating charts per venue"

      # NullQueueAdapter.suppress_queues do
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

      shows_count.times do
        FactoryBot.create(
          :show,
          artist: artists.sample,
          sections_count: 4,
          section_seats_count: 90,
          venue: venues.sample,
          venue_layout_blob: venue_layout_blob)
        Faker::SeatingChart.unique.clear
      end
      # end
      puts "Shows created"
    end
  end
end

Rake::Task["db:factories:load"].enhance(["tmp:clear"])