class ShowsController < ApplicationController
  def index
    @shows = Show.all
  end

  def show
    @show = Show.includes({ sections: [:seats] }, :artist, :seating_chart).find(params[:id])
  end
end
