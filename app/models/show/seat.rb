class Show::Seat < ApplicationRecord
  belongs_to :section, class_name: "Show::Section", inverse_of: :seats, foreign_key: "show_section_id", touch: true
  belongs_to :reserved_by, class_name: "User", inverse_of: :reserved_seats, foreign_key: "reserved_by_id", optional: true

  delegate :show, to: :section

  validates :x, presence: true
  validates :y, presence: true
  validates :seat_number, presence: true
  validates :table_number, presence: true

  after_update_commit :queue_expiration_job, if: -> { saved_change_to_reserved_until? || saved_change_to_reserved_by_id? }
  after_update_commit -> { broadcast_replace_to [self.show.id, "seating_chart"], partial: "shows/seats/seat" }, if: -> { saved_change_to_reserved_by_id? }

  def self.build_from_seating_chart_seat(seating_chart_seat)
    return new do |seat|
      seat.x = seating_chart_seat.x
      seat.y = seating_chart_seat.y
      seat.seat_number = seating_chart_seat.seat_number
      seat.table_number = seating_chart_seat.table_number
    end
  end

  def reserve
    return unless reserved_by.nil? || reserved_by == Current.user || reserved_until.past?

    with_lock do
      update(reserved_by: Current.user, reserved_until: Time.current + 15.minutes)
    end
  end

  def cancel_reservation
    return unless reserved_by == Current.user

    with_lock do
      update(reserved_by: nil, reserved_until: nil)
    end
  end

  def queue_expiration_job
    return unless reserved_by_id || reserved_until

    ExpireSeatReservationJob.set(wait_until: self.reserved_until).perform_later(self.id)
  end
end
