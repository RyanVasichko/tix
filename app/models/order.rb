class Order < ApplicationRecord
  include Payable, Shippable, Billable

  belongs_to :user

  has_many :tickets, class_name: "Order::Ticket", inverse_of: :order do
    def build_for_seats(seats)
      seats.each { |seat| build(seat: seat, price: seat.section.ticket_price, show: seat.show) }
    end
  end

  has_many :seats, class_name: "Show::Seat", through: :tickets

  has_many :merch, class_name: "Order::Merch", inverse_of: :order do
    def build_for_shopping_cart_merch(shopping_cart_merch)
      shopping_cart_merch.each do |scm|
        build(
          merch: scm.merch,
          quantity: scm.quantity,
          unit_price: scm.merch.price,
          total_price: scm.merch.price * scm.quantity,
          option: scm.option,
          option_label: scm.merch.option_label,
          shopping_cart_merch_id: scm.id
        )
      end
    end
  end

  after_create_commit :set_order_number

  private

  def set_order_number
    current_month_year = Date.today.strftime("%b%y").upcase
    padded_id = id.to_s.rjust(5, "0")
    update(order_number: "#{current_month_year}#{padded_id}")
  end
end
