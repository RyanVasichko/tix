class Shows::ReservedSeating::TicketSelectionsController < ApplicationController
  before_action :set_seat, only: [:create, :destroy]

  def create
    @seat.ticket.select_for!(Current.user)
  end

  def destroy
    @seat.ticket.cancel_selection_for!(Current.user)
  end

  private

  def set_seat
    @seat = Shows::ReservedSeating.find(params[:reserved_seating_show_id]).seats.find(params[:seat_id])
  end
end
