class Order < ApplicationRecord
  belongs_to :user
  has_many :tickets, class_name: "Order::Ticket", inverse_of: :order
  has_many :seats, class_name: "Show::Seat", through: :tickets
  belongs_to :payment,
             class_name: "Order::Payment",
             inverse_of: "order",
             foreign_key: "order_payment_id",
             optional: true

  after_create_commit :set_order_number

  def self.build_for_user(user)
    user.orders.build do |order|
      user.reserved_seats.each { |seat| order.tickets << Ticket.build_for_seat(seat) }
      order.calculate_order_total
    end
  end

  def total_in_cents
    return (order_total * 100).to_i
  end

  def calculate_order_total
    self.order_total = tickets.sum { |t| t.price }
  end

  def process_payment(payment_method_id, save_payment_method: false)
    build_payment(stripe_payment_method_id: payment_method_id, amount_in_cents: total_in_cents)
    payment.process(save_payment_method)
  end

  private

  def set_order_number
    current_month_year = Date.today.strftime("%b%y").upcase
    padded_id = id.to_s.rjust(5, "0")
    update(order_number: "#{current_month_year}#{padded_id}")
  end
end
