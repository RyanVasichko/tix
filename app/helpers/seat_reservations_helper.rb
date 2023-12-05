module SeatReservationsHelper
  def remove_show_seat_reservation_path(show, seat)
    current_page?(action: "new", controller: "orders") ? order_seat_reservations_path(seat) : show_seat_reservation_path(show, seat)
  end
end
