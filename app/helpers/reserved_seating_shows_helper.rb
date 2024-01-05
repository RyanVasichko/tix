module ReservedSeatingShowsHelper
  def turbo_replace_seat(seat)
    turbo_stream.replace(dom_id(seat)) do
      render partial: "reserved_seating_shows/seats/seat", collection: [seat], as: :seat, cached: true
    end
  end

  def turbo_replace_seats(seats)
    seats.each { |seat| concat(turbo_replace_seat(seat)) }
  end
end
