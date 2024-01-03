module Order::BuildableForUser
  extend ActiveSupport::Concern

  class_methods do
    def build_for_user(user)
      build do |order|
        order.tickets << Order::ReservedSeatingTicket.build_for_seats(user.shopping_cart.seats)
        order.tickets << Order::GeneralAdmissionTicket.build_from_shopping_cart_tickets(user.shopping_cart.tickets)
        order.merch << Order::Merch.build_from_shopping_cart_merch(user.shopping_cart_merch)

        set_shipping_address(order, user)
        order.calculate_order_total
      end
    end

    private

    def set_shipping_address(order, user)
      return unless order.merch.any?

      if user.shipping_addresses.any?
        order.shipping_address = user.shipping_addresses.first.dup
      else
        shipping_address_params = { first_name: user.first_name, last_name: user.last_name }
        order.build_shipping_address(shipping_address_params)
      end
    end
  end
end
