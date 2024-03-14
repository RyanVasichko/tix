class ReservedSeatingShowsController < ApplicationController
  def show
    @show = Shows::ReservedSeating.includes(:sections, :artist, :venue_layout_attachment).find(params[:id])
  end
end
