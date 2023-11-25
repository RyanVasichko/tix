module ShowsHelper
  def background_image_for_show_seating_chart(show)
    venue_layout = show.seating_chart.venue_layout

    width = venue_layout.attachment.metadata['width']
    height = venue_layout.attachment.metadata['height']
    background_image = rails_blob_path(venue_layout)

    "background-image: url(#{background_image}); width: #{width}px; height: #{height}px;"
  end

  def preload_venue_layout_images
    unique_blob_ids = Show.upcoming.joins(:venue_layout_attachment).pluck('active_storage_attachments.blob_id').uniq
    unique_blobs = ActiveStorage::Blob.where(id: unique_blob_ids)

    link_tags = unique_blobs.map do |blob|
      path = rails_blob_path(blob)
      tag.link(rel: 'preload', href: path, as: 'image', type: blob.content_type)
    end
    safe_join(link_tags)
  end
end
