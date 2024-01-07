class Order < ApplicationRecord
  include Payable, Shippable, Billable, BuildableForUser, KeywordSearchable

  belongs_to :orderer, polymorphic: true
  has_many :tickets, inverse_of: :order
  has_many :shows, through: :tickets
  has_many :reserved_seating_tickets, class_name: "Order::ReservedSeatingTicket", inverse_of: :order
  has_many :seats, class_name: "Show::Seat", through: :reserved_seating_tickets
  has_many :merch, class_name: "Order::Merch", inverse_of: :order

  after_create_commit :set_order_number

  def total_fees
    tickets.sum(&:total_fees)
  end

  def tickets_count
    tickets.sum(:quantity) + seats.count
  end

  private

  def set_order_number
    current_month_year = Date.today.strftime("%b%y").upcase
    padded_id = id.to_s.rjust(5, "0")
    update(order_number: "#{current_month_year}#{padded_id}")
  end
end
