class Shows::SeatReservationsController < ApplicationController
  before_action :set_show_and_seat, only: %i[ create destroy ]
  def create
    @seat.reserve
  end

  def destroy
    @seat.cancel_reservation
  end

  def set_show_and_seat
    @show = Show.find(params[:show_id])
    @seat = @show.seats.find(params[:seat_id])
  end
end