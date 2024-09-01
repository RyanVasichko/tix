class ShowsController < ApplicationController
  def index
    @pagy, @shows = pagy(Show.upcoming.order(:show_date), items: 20)
  end
end
