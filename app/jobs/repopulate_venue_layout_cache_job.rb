class RepopulateVenueLayoutCacheJob < ApplicationJob
  include ShowsHelper
  include Rails.application.routes.url_helpers # included so that rails_blob_path works in background jobs
  include ActionView::Helpers::AssetTagHelper # included so that tag.link works in background jobs
  queue_as :default

  def perform
    Rails.cache.delete('venue_layout_images_preload')
    Rails.cache.write('venue_layout_images_preload', preload_venue_layout_images)
  end

  private

  def default_url_options
    # Just use dummy data since we're only generating the path
    { host: "dont-need.com" }
  end
end
