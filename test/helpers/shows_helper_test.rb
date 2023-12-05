require "test_helper"

class ShowsHelperTest < ActionView::TestCase
  include ShowsHelper

  test "preload_venue_layout_images generates unique preload links for each image" do
    # Create two shows with the same venue_layout
    venue_layout_blob = ActiveStorage::Blob.create_and_upload!(
      io: File.open(Rails.root.join("test", "fixtures", "files", "seating_chart.bmp")),
      filename: "seating_chart.bmp",
      content_type: "image/bmp"
    )
    lcd_soundsystem_blob = ActiveStorage::Blob.create_and_upload!(
      io: File.open(Rails.root.join("test", "fixtures", "files", "lcd_soundsystem.webp")),
      filename: "lcd_soundsystem.webp",
      content_type: "image/webp"
    )
    radiohead_blob = ActiveStorage::Blob.create_and_upload!(
      io: File.open(Rails.root.join("test", "fixtures", "files", "radiohead.jpg")),
      filename: "radiohead.jpg",
      content_type: "image/jpeg"
    )

    2.times { FactoryBot.create(:reserved_seating_show, venue_layout_blob: venue_layout_blob) }
    FactoryBot.create(:reserved_seating_show, venue_layout_blob: lcd_soundsystem_blob)
    FactoryBot.create(:reserved_seating_show, :past, venue_layout_blob: radiohead_blob)

    preload_links_document = Nokogiri::HTML(preload_venue_layout_images)
    hrefs = preload_links_document.css('link[rel="preload"]').map { |link| link["href"] }

    expected_urls = [
      rails_blob_url(venue_layout_blob, only_path: true),
      rails_blob_url(lcd_soundsystem_blob, only_path: true)
    ]

    expected_urls.each do |expected_url|
      assert_includes hrefs, expected_url, "The preload links should include the URL: #{expected_url}"
    end

    assert_equal 2, hrefs.count
  end
end
