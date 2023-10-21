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
end
