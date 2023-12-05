class ReservedSeatingShowsController < ApplicationController
  def show
    @show = Show::ReservedSeatingShow.includes(:sections, :artist, :venue_layout_attachment).find(params[:id])
  end
end
