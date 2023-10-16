class ShoppingCart::SeatReservationsController < ApplicationController
  def destroy
    @seat = Current.user.reserved_seats.find(params[:seat_id])
    @seat.skip_broadcasting_shopping_cart = true
    @seat.cancel_reservation!

    redirect_back fallback_location: @seat.show, flash: { success: "Seat was successfully removed from your shopping cart." }, status: :see_other
  end
end
