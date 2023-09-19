class Orders::SeatReservationsController < ApplicationController
  def destroy
    @seat = Current.user.reserved_seats.find(params[:id])
    @seat.cancel_reservation!

    Current.user.reload
    @order = Current.user.order_form_type.for_user(Current.user)

    respond_to do |format|
      format.html { redirect_to new_order_path }
      format.turbo_stream
    end
  end
end