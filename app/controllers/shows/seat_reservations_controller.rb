class Shows::SeatReservationsController < ApplicationController
  before_action :set_show
  def create
    @seat = @show.seats.find(params[:seat_id])

    @seat.reserve_for(Current.user)

    redirect_back_or_to @show, status: :see_other
  end

  def destroy
    @seat = Current.user.reserved_seats.find(params[:seat_id])
    @seat.cancel_reservation!

    redirect_back_or_to @show, status: :see_other
  end

  private

  def set_show
    @show = Show.find(params[:show_id])
  end
end
