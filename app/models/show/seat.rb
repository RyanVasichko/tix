class Show::Seat < ApplicationRecord
  include Reservable

  belongs_to :section, class_name: "Show::Section", inverse_of: :seats, foreign_key: "show_section_id", touch: true
  has_one :show, through: :section
  has_one :ticket, class_name: "Order::Ticket", inverse_of: :seat, foreign_key: "show_seat_id"
  has_one :sold_to_user, through: :ticket, source: :user

  validates :x, presence: true
  validates :y, presence: true
  validates :seat_number, presence: true
  validates :table_number, presence: true

  def self.build_from_seating_chart_seat(seating_chart_seat)
    return new do |seat|
      seat.x = seating_chart_seat.x
      seat.y = seating_chart_seat.y
      seat.seat_number = seating_chart_seat.seat_number
      seat.table_number = seating_chart_seat.table_number
    end
  end
end
