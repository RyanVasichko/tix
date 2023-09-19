class Shows::SeatReservationsController < ApplicationController
  def create
    @show = Show.find(params[:show_id])
    @seat = @show.seats.find(params[:seat_id])

    @seat.reserve_for(Current.user)

    respond_to do |format|
      format.html { redirect_to show_path(@show), flash: { success: "Your seat has been reserved"} }
      format.turbo_stream
    end
  end

  def destroy
    @seat = Current.user.reserved_seats.find(params[:seat_id])
    @seat.skip_broadcasting_shopping_cart = true
    @seat.cancel_reservation!
    Current.user.reserved_seats.reload

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.turbo_stream
    end
  end
end
