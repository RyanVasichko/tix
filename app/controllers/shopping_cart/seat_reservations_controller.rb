class ShoppingCart::SeatReservationsController < ApplicationController
  def destroy
    @seat = Current.user.reserved_seats.find(params[:seat_id])
    @seat.cancel_reservation!

    head :no_content
  end
end
