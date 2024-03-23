module Shows::ReservedSeatingHelper
  def turbo_replace_seat(seat)
    turbo_stream.replace(dom_id(seat)) do
      render partial: "shows/reserved_seating/seats/seat", collection: [seat], as: :seat, cached: true
    end
  end

  def turbo_replace_seats(seats)
    safe_join(seats.map { |seat| turbo_replace_seat(seat) })
  end
end
