namespace :db do
  namespace :factories do
    task load: [:environment, "db:schema:load"] do
      class NullQueueAdapter
        def enqueue(job, *args)
        end

        def enqueue_at(job, timestamp, *args)
        end
      end


      artist_image_blob = ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join('test', 'fixtures', 'files', 'radiohead.jpg')),
        filename: 'radiohead.jpg',
        content_type: 'image/jpeg'
      )

      artists_count = ENV.fetch("ARTISTS_COUNT") { 20 }.to_i
      shows_count = ENV.fetch("SHOWS_COUNT") { 50 }.to_i
      puts "Creating #{artists_count} artists and #{shows_count} shows"

      old_queue_adapter = ActiveJob::Base.queue_adapter
      ActiveJob::Base.queue_adapter = NullQueueAdapter.new

      artists = FactoryBot.create_list(:artist, artists_count).each do |artist|
        artist.image.attach(artist_image_blob)
      end

      puts "Artists created"

      seating_charts = FactoryBot.create_list(:seating_chart, 4, sections_count: 4, section_seats_count: 20)

      puts "Seating charts created"

      shows_count.times do
        FactoryBot.create(
          :show,
          :skip_seating_chart,
          :skip_artist,
          seating_chart: seating_charts.sample,
          artist: artists.sample)
      end

      ActiveJob::Base.queue_adapter = old_queue_adapter

      SeatingChart.all.each do |seating_chart|
        seating_chart.venue_layout.analyze unless seating_chart.venue_layout.analyzed?
      end

      puts "Shows created"
    end
  end
end