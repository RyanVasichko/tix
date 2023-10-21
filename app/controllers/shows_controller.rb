class ShowsController < ApplicationController
  def index
    @shows = Show.all.includes(artist: { image_attachment: :blob })
  end

  def show
    @show = Show.includes(
      {
        sections: [seats: [:show, ticket: { order: :orderer }]]
      },
      :artist).find(params[:id])
  end
end
