class Order::Ticket < ApplicationRecord
  belongs_to :order, inverse_of: :tickets
  belongs_to :seat, class_name: "Show::Seat", inverse_of: :ticket, foreign_key: "show_seat_id", touch: true
  belongs_to :show, inverse_of: :tickets

  validates :convenience_fees, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :venue_commission, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :ticket_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  delegate :seat_number, to: :seat
  delegate :table_number, to: :seat

  def orderer
    order.orderer
  end

  def self.build_for_seat(seat)
    build(seat: seat, show: seat.show).tap do |ticket|
      ticket.set_pricing_from_seat
    end
  end

  def set_pricing_from_seat
    self.ticket_price = seat.section.ticket_price
    self.convenience_fees = seat.section.seat_convenience_fees
    self.venue_commission = seat.section.venue_commission
    self.total_price = ticket_price + convenience_fees + venue_commission
  end

  def self.build_for_seats(seats)
    seats.map { |seat| build_for_seat(seat) }
  end
end
