class ExpireSeatReservationJob < ApplicationJob
  queue_as :default

  def perform(seat_id)
    seat = Show::Seat.find(seat_id)

    return unless seat

    if seat.reserved_until&.past?
      seat.with_lock do
        seat.update!(shopping_cart: nil, reserved_until: nil)
      end
    elsif seat.reserved_until
      self.class.set(wait_until: seat.reserved_until).perform_later(seat_id)
    end
  end
end
