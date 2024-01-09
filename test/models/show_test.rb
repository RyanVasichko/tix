require "test_helper"

class ShowTest < ActiveSupport::TestCase
  test "should sync start and end time with show date" do
    show = FactoryBot.build(:reserved_seating_show)

    next_year = Time.current.year + 1

    show.show_date = Date.new(next_year, 9, 19)
    show.show_starts_at = Time.zone.local(2000, 1, 1, 15, 0, 0)
    show.doors_open_at = Time.zone.local(2000, 1, 1, 14, 0, 0)
    show.dinner_starts_at = Time.zone.local(2000, 1, 1, 14, 0, 0)
    show.dinner_ends_at = Time.zone.local(2000, 1, 1, 15, 0, 0)

    show.save

    assert_equal Time.zone.local(next_year, 9, 19, 15, 0, 0), show.show_starts_at
    assert_equal Time.zone.local(next_year, 9, 19, 14, 0, 0), show.doors_open_at
    assert_equal Time.zone.local(next_year, 9, 19, 14, 0, 0), show.dinner_starts_at
    assert_equal Time.zone.local(next_year, 9, 19, 15, 0, 0), show.dinner_ends_at
  end

  test "should bust the venue layout cache when a show is created" do
    Rails.cache.write("venue_layout_images_preload", "old_data", expires_in: 1.day)

    FactoryBot.create(:reserved_seating_show)
    perform_enqueued_jobs
    assert_nil Rails.cache.read("venue_layout_images_preload")
  end

  test "should rebuild the order index when the artist changes" do
    skip "I can't get order_search_indices to create in test environment"

    show = FactoryBot.create(:reserved_seating_show)
    order = FactoryBot.create(:customer_order, with_existing_shows: true)

    show.artist = FactoryBot.create(:artist)
    show.save

    perform_enqueued_jobs

    assert Order::SearchIndex.find_by(order_id: order.id)
  end
end
