# Giga seed:
# PROCESS_COUNT=8 ARTISTS_COUNT=125 UPCOMING_GENERAL_ADMISSION_SHOWS_COUNT=60 UPCOMING_RESERVED_SEATING_SHOWS_COUNT=60 PAST_GENERAL_ADMISSION_SHOWS_COUNT=1000 PAST_RESERVED_SEATING_SHOWS_COUNT=1000 CUSTOMERS_COUNT=500 CUSTOMER_ORDERS_COUNT=500 GUEST_ORDERS_COUNT=500 bin/rails db:factories:load

namespace :db do
  namespace :factories do
    task load: [:environment, "db:reset"] do
      start = Time.current

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

      artists_count = ENV.fetch("ARTISTS_COUNT", 20).to_i
      upcoming_general_admission_shows_count = ENV.fetch("UPCOMING_GENERAL_ADMISSION_SHOWS_COUNT", 20).to_i
      past_general_admission_shows_count = ENV.fetch("PAST_GENERAL_ADMISSION_SHOWS_COUNT", 20).to_i
      upcoming_reserved_seating_shows_count = ENV.fetch("UPCOMING_RESERVED_SEATING_SHOWS_COUNT", 20).to_i
      past_reserved_seating_shows_count = ENV.fetch("PAST_RESERVED_SEATING_SHOWS_COUNT", 20).to_i
      venue_seating_charts_count = ENV.fetch("VENUE_SEATING_CHARTS_COUNT", 2).to_i
      venues_count = ENV.fetch("VENUES_COUNT", 3).to_i
      merch_count = ENV.fetch("MERCH_COUNT", 5).to_i
      merch_categories_count = ENV.fetch("MERCH_CATEGORIES_COUNT", 5).to_i
      merch_shipping_rates_count = ENV.fetch("MERCH_shipping_rateS_COUNT", 3).to_i
      customers_count = ENV.fetch("CUSTOMERS_COUNT", 10).to_i
      admins_count = ENV.fetch("ADMINS_COUNT", 1).to_i
      customer_orders_count = ENV.fetch("CUSTOMER_ORDERS_COUNT", 10).to_i
      guest_orders_count = ENV.fetch("GUEST_ORDERS_COUNT", 10).to_i

      puts "Creating:"

      (1 .. artists_count).map { FactoryBot.create(:artist, image_blob: artist_image_blobs.sample) }
      puts "- #{artists_count} artists"

      venues = (1 .. venues_count).map { FactoryBot.create(:venue) }
      puts "- #{venues_count} venues"

      venue_layout_blob = ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join("test", "fixtures", "files", "seating_chart.bmp")),
        filename: "seating_chart.bmp",
        content_type: "image/bmp"
      )

      venues.each do |venue|
        (1 ... venue_seating_charts_count).each_slice(100) do |slice|
          slice.count.times do
            FactoryBot.create(
              :seating_chart,
              sections_count: 4,
              section_seats_count: 90,
              venue_layout_blob: venue_layout_blob,
              venue: venue)
            Faker::SeatingChart.unique.clear
          end
        end
      end
      puts "- #{venue_seating_charts_count} seating charts per venue"

      Show::Seat.suppressing_turbo_broadcasts do
        with_forking do
          (1 .. upcoming_reserved_seating_shows_count).each_slice(100) do |slice|
            slice.count.times do
              FactoryBot.create(
                :reserved_seating_show,
                with_existing_artist: true,
                sections_count: 4,
                section_tickets_count: 90,
                with_existing_venue: true,
                venue_layout_blob: venue_layout_blob)
              Faker::SeatingChart.unique.clear
            end
          end
        end
        puts "- #{upcoming_reserved_seating_shows_count} upcoming reserved seating shows"

        with_forking do
          (1 .. past_reserved_seating_shows_count).each_slice(100) do |slice|
            slice.count.times do
              FactoryBot.create(
                :reserved_seating_show,
                :past,
                with_existing_artist: true,
                sections_count: 4,
                section_tickets_count: 90,
                with_existing_venue: true,
                venue_layout_blob: venue_layout_blob)
              Faker::SeatingChart.unique.clear
            end
          end
        end
        puts "- #{upcoming_reserved_seating_shows_count} past reserved seating shows"
      end

      with_forking do
        (1 .. upcoming_general_admission_shows_count).each_slice(100) do |slice|
          FactoryBot.create_list(
            :general_admission_show,
            slice.count,
            with_existing_artist: true,
            sections_count: 2,
            with_existing_venue: true)
        end
      end
      puts "- #{upcoming_general_admission_shows_count} upcoming general admission shows"

      with_forking do
        (1 .. past_general_admission_shows_count).each_slice(100) do |slice|
          FactoryBot.create_list(
            :general_admission_show,
            slice.count,
            :past,
            with_existing_artist: true,
            sections_count: 2,
            with_existing_venue: true)
        end
      end
      puts "- #{past_general_admission_shows_count} past general admission shows"

      merch_categories = FactoryBot.create_list(:merch_category, merch_categories_count)
      puts "- #{merch_categories_count} merch categories"

      merch_image_blob = ActiveStorage::Blob.create_and_upload! \
        io: File.open(Rails.root.join("test/fixtures/files/bbq_sauce.png")),
        filename: "bbq_sauce.png",
        content_type: "image/png"
      merch_count.times do
        FactoryBot.create(:merch, categories: merch_categories.sample(2), image_blob: merch_image_blob)
      end
      puts "- #{merch_count} merch"

      merch_shipping_rates_count.times do |index|
        Merch::ShippingRate.create!(weight: index * 5, price: index + 1)
      end
      puts "- #{merch_shipping_rates_count} merch shipping rates"

      with_forking do
        (1 .. customers_count).each_slice(100) do |slice|
          FactoryBot.create_list(:customer, slice.count)
        end
      end
      puts "- #{customers_count} customers"

      FactoryBot.create(:admin, password: "password", password_confirmation: "password", email: "fake_admin@test.com")
      FactoryBot.create_list(:admin, admins_count)
      puts "- #{admins_count} admins"

      Show::Seat.suppressing_turbo_broadcasts do
        with_forking do
          (1 .. customer_orders_count).each_slice(100) do |slice|
            truncate_wal_file

            FactoryBot.create_list(:customer_order, slice.count, with_existing_shows: true, with_existing_user: true, with_existing_merch: true)
          end
        end
        puts "- #{customer_orders_count} customer orders"

        with_forking do
          (1 .. guest_orders_count).each_slice(100) do |slice|
            truncate_wal_file

            FactoryBot.create_list(:guest_order, slice.count, with_existing_shows: true, with_existing_merch: true)
          end
        end
        puts "- #{guest_orders_count} guest orders"
      end

      puts "Factories loaded. Total time: #{Time.current - start}"
    end
  end
end

def with_forking(&block)
  process_count = ENV.fetch("PROCESS_COUNT", 1).to_i
  return yield if process_count == 1

  process_count.times.map { Process.fork(&block) }
  statuses = Process.waitall.map { |pid, status| status }

  truncate_wal_file

  raise "An error occurred in one of the forked processes" if statuses.any? { |status| status.exitstatus != 0 }
end

def truncate_wal_file
  ApplicationRecord.connection_pool.with_connection do |connection|
    connection.execute("PRAGMA wal_checkpoint(TRUNCATE);")
  end
end

Rake::Task["db:factories:load"].enhance(["tmp:clear"])
