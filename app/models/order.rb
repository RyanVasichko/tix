class Order < ApplicationRecord
  include Payable, Shippable, Billable

  belongs_to :orderer, polymorphic: true
  has_many :tickets, inverse_of: :order
  has_many :reserved_seating_tickets, class_name: "Order::ReservedSeatingTicket", inverse_of: :order
  has_many :seats, class_name: "Show::Seat", through: :reserved_seating_tickets

  has_many :merch, class_name: "Order::Merch", inverse_of: :order do
    def build_from_shopping_cart_merch(shopping_cart_merch)
      shopping_cart_merch.each do |scm|
        build(
          merch: scm.merch,
          quantity: scm.quantity,
          unit_price: scm.merch.price,
          total_price: scm.merch.price * scm.quantity,
          option: scm.option,
          option_label: scm.merch.option_label,
          shopping_cart_merch: scm
        )
      end
    end
  end

  after_create_commit :set_order_number

  def self.build_for_user(user)
    set_shipping_address = -> (order) do
      if user.shipping_addresses.any?
        order.shipping_address = user.shipping_addresses.first.dup
      else
        shipping_address_params = { first_name: user.first_name, last_name: user.last_name }
        order.build_shipping_address(shipping_address_params)
      end
    end

    build do |order|
      order.tickets << Order::ReservedSeatingTicket.build_for_seats(user.shopping_cart.seats)
      order.tickets << Order::GeneralAdmissionTicket.build_from_shopping_cart_tickets(user.shopping_cart.tickets)
      order.merch.build_from_shopping_cart_merch(user.shopping_cart_merch)

      set_shipping_address.call(order) if order.merch.any?
      order.calculate_order_total
    end
  end

  def total_fees
    tickets.sum(&:total_fees)
  end

  private

  def set_order_number
    current_month_year = Date.today.strftime("%b%y").upcase
    padded_id = id.to_s.rjust(5, "0")
    update(order_number: "#{current_month_year}#{padded_id}")
  end
end
