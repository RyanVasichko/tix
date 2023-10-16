class Shows::SeatReservationsController < ApplicationController
  def create
    @show = Show.find(params[:show_id])
    @seat = @show.seats.find(params[:seat_id])

    @seat.reserve_for(Current.user)

    head :no_content
  end

  def destroy
    @seat = Current.user.reserved_seats.find(params[:seat_id])
    @seat.skip_broadcasting_shopping_cart = true
    @seat.cancel_reservation!

    head :no_content
  end
end
