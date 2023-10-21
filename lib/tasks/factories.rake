require Rails.root.join("lib", "tasks", "factories_helpers", "null_queue_adapter")

namespace :db do
  namespace :factories do
    task load: [:environment, "db:schema:load"] do
      artist_image_blob = ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join('test', 'fixtures', 'files', 'radiohead.jpg')),
        filename: 'radiohead.jpg',
        content_type: 'image/jpeg'
      )

      artists_count = ENV.fetch("ARTISTS_COUNT") { 20 }.to_i
      shows_count = ENV.fetch("SHOWS_COUNT") { 50 }.to_i
      puts "Creating #{artists_count} artists and #{shows_count} shows"

      NullQueueAdapter.suppress_queues do
        artists = FactoryBot.create_list(:artist, artists_count).each do |artist|
          artist.image.attach(artist_image_blob)
        end

        puts "Artists created"

        4.times do
          FactoryBot.create(:seating_chart, sections_count: 4, section_seats_count: 20)
          Faker::SeatingChart.unique.clear
        end

        puts "Seating charts created"

        shows_count.times do
          FactoryBot.create(
            :show,
            artist: artists.sample)
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