class ShoppingCart::SeatReservationsController < ApplicationController
  def destroy
    @seat = Current.user.reserved_seats.find(params[:seat_id])
    @seat.cancel_reservation!

    respond_to do |format|
      format.html { redirect_back_or_to @seat.show, status: :see_other }
      format.turbo_stream
    end
  end
end
