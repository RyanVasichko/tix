module FactoryRunners
  module HasVenueLayout
    protected

    VENUE_LAYOUT_BLOB = ActiveStorage::Blob.create_and_upload! \
      io: File.open(Rails.root.join("test", "fixtures", "files", "seating_chart.bmp")),
      filename: "seating_chart.bmp",
      content_type: "image/bmp"
  end
end
