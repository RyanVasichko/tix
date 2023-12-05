class Order::ReservedSeatingTicket < Order::Ticket
  belongs_to :seat, class_name: "Show::Seat", inverse_of: :ticket, foreign_key: "show_seat_id", touch: true
  belongs_to :show, class_name: "Show::ReservedSeatingShow", inverse_of: :tickets, foreign_key: "show_id"
  validates :seat, presence: true
  delegate :seat_number, to: :seat
  delegate :table_number, to: :seat

  after_initialize -> { self.quantity = 1 }, if: :new_record?

  def self.build_for_seats(seats)
    seats.map { |seat| build_for_seat(seat) }
  end

  def self.build_for_seat(seat)
    build(seat: seat, show: seat.show).tap(&:set_pricing_from_seat)
  end

  def set_pricing_from_seat
    self.ticket_price = seat.section.ticket_price
    self.convenience_fees = seat.section.ticket_convenience_fees
    self.venue_commission = seat.section.venue_commission
    self.total_price = ticket_price + convenience_fees + venue_commission
  end
end
