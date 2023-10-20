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

        seating_charts = FactoryBot.create_list(:seating_chart, 4, sections_count: 4, section_seats_count: 20)

        puts "Seating charts created"

        shows_count.times do
          FactoryBot.create(
            :show,
            seating_chart: seating_charts.sample,
            artist: artists.sample)
        end
      end

      SeatingChart.all.each do |seating_chart|
        seating_chart.venue_layout.analyze unless seating_chart.venue_layout.analyzed?
      end

      puts "Shows created"
    end
  end
end