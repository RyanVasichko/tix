class Shows::ReservedSeating::SeatHoldsController < ApplicationController
  include SearchParams

  sortable_by :seat_number, :table_number, :held_by_name
  self.default_sort_field = :table_number

  before_action :set_show

  def create
    @seats = @show.seats.selected_by(Current.user)

    ActiveRecord::Base.transaction do
      @seats.each do |seat|
        seat.hold_for!(Current.user)
      end
    end

    respond_to do |format|
      notice = "Seats were successfully held."
      format.html { redirect_back_or_to root_path, flash: { notice: notice } }
      format.turbo_stream { flash.now[:notice] = notice }
    end
  end

  def index
    set_held_seats_and_pagy
  end

  def destroy
    @seat = @show.seats.held.find(params[:id])
    @seat.release_hold!(Current.user)

    set_held_seats_and_pagy

    respond_to do |format|
      notice = "Seat hold was successfully released."
      format.html { redirect_back_or_to root_path, flash: { notice: notice } }
      format.turbo_stream { flash.now[:notice] = notice }
    end
  end

  private

  def set_show
    @show = Show.find(params[:reserved_seating_show_id])
  end

  def set_held_seats_and_pagy
    @held_seats = @show.seats.held
    @held_seats = @held_seats.seat_holds_keyword_search(search_keyword) if search_keyword.present?
    @held_seats = @held_seats.search(search_params.except(:q))

    @pagy, @held_seats = pagy(@held_seats, items: 10)
  end
end
