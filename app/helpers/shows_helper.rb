module ShowsHelper
  def background_image_for_show_seating_chart(show)
    venue_layout = show.seating_chart.venue_layout

    width = venue_layout.attachment.metadata["width"]
    height = venue_layout.attachment.metadata["height"]
    background_image = rails_blob_path(venue_layout)

    "background-image: url(#{background_image}); width: #{width}px; height: #{height}px;"
  end

  def link_to_order_tickets(show)
    data_attributes = show.is_a?(Shows::GeneralAdmission) ? { turbo: "", turbo_stream: "" } : {}
    path = if show.is_a?(Shows::ReservedSeating)
             shows_reserved_seating_path(show)
           else
             new_shows_general_admission_ticket_selections_path(show)
           end

    link_to "Order Tickets",
            path,
            data: data_attributes,
            class: "button primary w-full px-4 py-3"
  end
end
