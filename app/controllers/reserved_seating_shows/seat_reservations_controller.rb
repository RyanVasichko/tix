class ReservedSeatingShows::SeatReservationsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: -> { redirect_back_or_to root_path, status: :see_other }

  def create
    @seat = Show::Seat.find(params[:seat_id])
    @seat.reserve_for!(Current.user)

    respond_to do |format|
      format.html { redirect_back_or_to shows_path(@seat.show), status: :see_other }
      format.turbo_stream
    end
  end

  def destroy
    @seat = Current.user.reserved_seats.find(params[:seat_id])
    @seat.cancel_reservation_for!(Current.user)

    respond_to do |format|
      format.html { redirect_back_or_to shows_path(@seat.show), status: :see_other }
      format.turbo_stream
    end
  end
end