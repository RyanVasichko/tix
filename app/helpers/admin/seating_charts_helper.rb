module Admin::SeatingChartsHelper
  def seating_chart_svg_style(seating_chart, venue_layout_signed_id = nil)
    venue_layout = venue_layout_signed_id ? ActiveStorage::Blob.find_signed(venue_layout_signed_id) : seating_chart.venue_layout

    if venue_layout.attached?
      width = venue_layout.attachment.metadata["width"]
      height = venue_layout.attachment.metadata["height"]
      background_image = rails_blob_path(venue_layout)

      "background-image: url(#{background_image}); width: #{width}px; height: #{height}px;"
    else
      "width: 100%; height: 500px;"
    end
  end
end
