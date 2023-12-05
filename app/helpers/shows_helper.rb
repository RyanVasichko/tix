module ShowsHelper
  def background_image_for_show_seating_chart(show)
    venue_layout = show.seating_chart.venue_layout

    width = venue_layout.attachment.metadata["width"]
    height = venue_layout.attachment.metadata["height"]
    background_image = rails_blob_path(venue_layout)

    "background-image: url(#{background_image}); width: #{width}px; height: #{height}px;"
  end

  def show_path(show)
    if show.is_a?(Show::ReservedSeatingShow)
      reserved_seating_show_path(show)
    else
      new_shopping_cart_general_admission_show_ticket_url(show)
    end
  end

  def link_to_order_tickets(show)
    data_attributes = show.is_a?(Show::GeneralAdmissionShow) ? { turbo: "", turbo_stream: "" } : {}
    link_to "Order Tickets",
            show_path(show),
            data: data_attributes,
            class: "group flex items-center justify-center w-full rounded-md border border-transparent bg-indigo-600 px-4 py-3 text-base font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 focus:ring-offset-gray-50"
  end

  def preload_venue_layout_images
    unique_blob_ids = Show::ReservedSeatingShow.upcoming
                                               .joins(:venue_layout_attachment)
                                               .select(Arel.sql("DISTINCT active_storage_attachments.blob_id"))
    unique_blobs = ActiveStorage::Blob.where(id: unique_blob_ids)

    link_tags = unique_blobs.map do |blob|
      path = rails_blob_path(blob)
      tag.link(rel: "preload", href: path, as: "image", type: blob.content_type)
    end
    safe_join(link_tags)
  end
end
