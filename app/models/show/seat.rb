class Show::Seat < ApplicationRecord
  include Reservable, Holdable

  belongs_to :section, class_name: "Show::Section", inverse_of: :seats, foreign_key: "show_section_id", touch: true
  delegate :ticket_price, :deposit?, to: :section

  has_one :show, through: :section
  delegate :deposit_amount, to: :show
  has_one :ticket, class_name: "Order::ReservedSeatingTicket", inverse_of: :seat, foreign_key: "show_seat_id"

  validates :x, presence: true
  validates :y, presence: true
  validates :seat_number, presence: true
  validates :table_number, presence: true

  scope :sold, -> { joins(:ticket) }
  scope :not_sold, -> { left_outer_joins(:ticket).where(ticket: { id: nil }) }

  def self.build_from_seating_chart_seat(seating_chart_seat)
    build(
      x: seating_chart_seat.x,
      y: seating_chart_seat.y,
      seat_number: seating_chart_seat.seat_number,
      table_number: seating_chart_seat.table_number
    )
  end

  def orderer
    ticket&.orderer
  end

  def sold?
    ticket.present?
  end
end
