class Order::Ticket < ApplicationRecord
  belongs_to :order, inverse_of: :tickets
  belongs_to :seat, class_name: "Show::Seat", inverse_of: :ticket, foreign_key: "show_seat_id", touch: true
  belongs_to :show, inverse_of: :tickets
  has_one :user, through: :order


  delegate :seat_number, to: :seat
  delegate :table_number, to: :seat

  def self.build_for_seat(seat)
    new(seat: seat, price: seat.section.ticket_price, show: seat.show)
  end
end
