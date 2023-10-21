class Order::Ticket < ApplicationRecord
  belongs_to :order, inverse_of: :tickets
  belongs_to :seat, class_name: "Show::Seat", inverse_of: :ticket, foreign_key: "show_seat_id", touch: true
  belongs_to :show, inverse_of: :tickets

  delegate :seat_number, to: :seat
  delegate :table_number, to: :seat

  def orderer
    order.orderer
  end
end
