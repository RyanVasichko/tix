require "test_helper"

class RepopulateVenueLayoutCacheJobTest < ActiveJob::TestCase
  test "repopulates the venue layout cache" do
    Rails.cache.write('venue_layout_images_preload', 'old_data')
    RepopulateVenueLayoutCacheJob.perform_now
    assert_not_equal 'old_data', Rails.cache.read('venue_layout_images_preload')
  end
end
