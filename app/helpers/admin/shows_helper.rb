module Admin::ShowsHelper
  def artist_combobox_options_for_show(show)
    artists = if show.persisted?
                Artist.where(id: show.artist_id)
              else
                Artist.active.order(:name)
              end

    artists.pluck(:name, :id)
  end
end
