module ShowsHelper
  def background_image_for_show_seating_chart(show)
    venue_layout = show.seating_chart.venue_layout

    width = venue_layout.attachment.metadata["width"]
    height = venue_layout.attachment.metadata["height"]
    background_image = rails_blob_path(venue_layout)

    "background-image: url(#{background_image}); width: #{width}px; height: #{height}px;"
  end

  def show_path(show)
    if show.is_a?(Shows::ReservedSeating)
      reserved_seating_show_path(show)
    else
      new_shopping_cart_general_admission_show_ticket_url(show)
    end
  end

  def link_to_order_tickets(show)
    data_attributes = show.is_a?(Shows::GeneralAdmission) ? { turbo: "", turbo_stream: "" } : {}
    link_to "Order Tickets",
            show_path(show),
            data: data_attributes,
            class: "group flex items-center justify-center w-full rounded-md border border-transparent bg-amber-600 px-4 py-3 text-base font-medium text-white shadow-sm hover:bg-amber-700 focus:outline-none focus:ring-2 focus:ring-amber-500 focus:ring-offset-2 focus:ring-offset-gray-50"
  end
end
