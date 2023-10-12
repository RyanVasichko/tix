module User::Shopper
  extend ActiveSupport::Concern

  included do
    has_many :reserved_seats,
             -> { where(reserved_until: Time.current..) },
             class_name: "Show::Seat",
             inverse_of: :reserved_by,
             foreign_key: "reserved_by_id"

    scope :includes_shopping_cart,
          -> {
            includes(
              shopping_cart_merch: {
                merch: [{ image_attachment: :blob }]
              },
              reserved_seats: [{ section: [{ show: :artist }, :seating_chart_section] }]
            )
          }

    has_many :shopping_cart_merch, class_name: "User::ShoppingCartMerch", inverse_of: :user

    has_many :orders do
      def build_for_user(user)
        set_shipping_address = -> (order) do
          if user.shipping_addresses.any?
            order.shipping_address = user.shipping_addresses.first.dup
          else
            shipping_address_params = { first_name: user.first_name, last_name: user.last_name }
            order.build_shipping_address(shipping_address_params)
          end
        end

        build do |order|
          order.tickets.build_for_seats(user.shopping_cart.seats)
          order.merch.build_for_shopping_cart_merch(user.shopping_cart.merch)

          set_shipping_address.call(order) if order.merch.any?
          order.calculate_order_total
        end
      end
    end

    has_many :shipping_addresses, class_name: "Order::ShippingAddress", through: :orders, source: :shipping_address
  end

  def shopping_cart
    @shopping_cart ||= User::ShoppingCart.new(self)
  end

  def ticket_reservation_time
    15.minutes
  end

  def has_reserved_seats_for_show?(show)
    reserved_seats.joins(:show).where(shows: { id: show }).exists?
  end
end
