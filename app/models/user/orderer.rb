module User::Orderer
  extend ActiveSupport::Concern

  included do
    before_commit :transfer_orders_to_guest_orderer, on: :destroy

    has_many :orders, as: :orderer
    has_many :shipping_addresses, class_name: "Order::ShippingAddress", through: :orders, source: :shipping_address
  end

  def transfer_orders_to_guest_orderer
    return unless orders.any?

    Order::GuestOrderer.create!(first_name: first_name,
                                last_name: last_name,
                                email: email,
                                phone: phone,
                                orders: orders)
  end
end
