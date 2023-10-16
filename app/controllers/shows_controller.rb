class ShowsController < ApplicationController
  def index
    @shows = Show.all.includes(artist: { image_attachment: :blob })
  end

  def show
    @show = Show.includes({ sections: [seats: [:sold_to_user, :show]] }, :artist, :seating_chart).find(params[:id])
  end
end
