class Shows::ReservedSeating::TicketSelectionsController < ApplicationController
  before_action :set_seat, only: [:create, :destroy]
  before_action :set_ticket_selection, only: [:destroy]

  def create
    @seat.ticket.select_for!(Current.user)
  end

  def destroy
    @ticket_selection.selectable.cancel_selection_for!(Current.user)
  end

  private

  def set_ticket_selection
    @ticket_selection = Current.user.shopping_cart.selections.tickets.find(params[:id])
  end

  def set_seat
    @seat = Shows::ReservedSeating.find(params[:reserved_seating_show_id]).seats.find(params[:seat_id])
  end
end
