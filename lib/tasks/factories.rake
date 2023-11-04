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
      shows_count = ENV.fetch("SHOWS_COUNT") { 50 }.to_i
      puts "Creating #{artists_count} artists and #{shows_count} shows"

      NullQueueAdapter.suppress_queues do
        artists = (1..artists_count).map { FactoryBot.create(:artist, image_blob: artist_image_blobs.sample) }

        puts "Artists created"

        venue_layout_blob = ActiveStorage::Blob.create_and_upload!(
          io: File.open(Rails.root.join("test", "fixtures", "files", "seating_chart.bmp")),
          filename: "seating_chart.bmp",
          content_type: "image/bmp"
        )
        4.times do
          FactoryBot.create(:seating_chart, sections_count: 4, section_seats_count: 20, venue_layout_blob: venue_layout_blob)
          Faker::SeatingChart.unique.clear
        end

        puts "Seating charts created"
        shows_count.times do
          FactoryBot.create(
            :show,
            artist: artists.sample,
            sections_count: 4,
            section_seats_count: 90,
            venue_layout_blob: venue_layout_blob)
          Faker::SeatingChart.unique.clear
        end
      end

      SeatingChart.all.each do |seating_chart|
        seating_chart.venue_layout.analyze unless seating_chart.venue_layout.analyzed?
      end
      Show.all.each do |show|
        show.venue_layout.analyze unless show.venue_layout.analyzed?
      end

      puts "Shows created"
    end
  end
end

Rake::Task["db:factories:load"].enhance(["tmp:clear"])