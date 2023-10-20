module User::Shopper
  extend ActiveSupport::Concern

  included do
    after_initialize :build_shopping_cart, if: :new_record?
    belongs_to :shopping_cart, class_name: "User::ShoppingCart", foreign_key: :user_shopping_cart_id, inverse_of: :user, dependent: :destroy
    has_many :reserved_seats, class_name: "Show::Seat", through: :shopping_cart, source: :seats
    has_many :shopping_cart_merch, class_name: "User::ShoppingCart::Merch", through: :shopping_cart, source: :merch

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
          order.merch.build_from_shopping_cart_merch(user.shopping_cart_merch)

          set_shipping_address.call(order) if order.merch.any?
          order.calculate_order_total
        end
      end
    end

    has_many :shipping_addresses, class_name: "Order::ShippingAddress", through: :orders, source: :shipping_address
  end

  def ticket_reservation_time
    15.minutes
  end

  def has_reserved_seats_for_show?(show)
    reserved_seats.joins(:show).where(shows: { id: show }).exists?
  end
end
