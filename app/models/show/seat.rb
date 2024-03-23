class Show::Seat < ApplicationRecord
  # Set up ticket association first because Reservable and Holdable depend on it
  belongs_to :ticket, class_name: "Tickets::ReservedSeating"

  include Selectable, Holdable, Searchable

  delegate :sold?, :purchaser, :purchaser_shopper_uuid, to: :ticket
  scope :sold, -> { joins(:ticket).merge(Ticket.sold) }
  scope :not_sold, -> { joins(:ticket).merge(Ticket.not_sold) }
  scope :available, -> { not_sold.not_held.not_selected }

  has_one :section, class_name: "Show::Section", through: :ticket, source: :show_section
  has_one :show, through: :section

  validates :x, presence: true
  validates :y, presence: true
  validates :seat_number, presence: true
  validates :table_number, presence: true

  orderable_by :seat_number, :table_number

  def self.build_from_seating_chart_seat(seating_chart_seat)
    build(
      x: seating_chart_seat.x,
      y: seating_chart_seat.y,
      seat_number: seating_chart_seat.seat_number,
      table_number: seating_chart_seat.table_number
    )
  end
end
