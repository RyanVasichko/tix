class ReservedSeatingShows::SeatHoldsController < ApplicationController
  before_action :set_show

  def create
    ActiveRecord::Base.transaction do
      @seats = @show.seats.merge(Current.user.shopping_cart.seats)
      @seats.each do |seat|
        seat.hold_for_admin!(Current.user)
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
      format.turbo_stream { flash[:notice] = notice }
    end
  end

  private

  def set_show
    @show = Show.find(params[:reserved_seating_show_id])
  end

  def set_held_seats_and_pagy
    @held_seats = @show.seats.held.order(:table_number)
    if search_keyword.present?
      @held_seats = @held_seats.joins(:held_by_admin).where(<<-SQL, keyword: "%#{search_keyword}%")
        CONCAT(users.first_name, ' ', users.last_name) LIKE :keyword
        OR show_seats.seat_number LIKE :keyword
        OR show_seats.table_number LIKE :keyword
      SQL
    end
    @pagy, @held_seats = pagy(@held_seats, items: 5)
  end

  def search_keyword
    params.dig(:search, :keyword)
  end
end
