module ShowsHelper
  def background_image_for_show_seating_chart(show)
    venue_layout = show.seating_chart.venue_layout

    width = venue_layout.attachment.metadata['width']
    height = venue_layout.attachment.metadata['height']
    background_image = rails_blob_path(venue_layout)

    "background-image: url(#{background_image}); width: #{width}px; height: #{height}px;"
  end
end
