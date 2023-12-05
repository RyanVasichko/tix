class Orders::SeatReservationsController < ApplicationController
  def destroy
    @seat = Current.user.reserved_seats.find(params[:id])
    @seat.cancel_reservation_for(Current.user)

    redirect_back_or_to root_path, status: :see_other, notice: "Your shopping cart has been updated."
  end
end
