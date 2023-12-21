class ShowsController < ApplicationController
  def index
    @pagy, @shows = pagy(Show.upcoming.includes(artist: { image_attachment: :blob }).order(:show_date), items: 20)
  end
end
