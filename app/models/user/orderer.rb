module User::Orderer
  extend ActiveSupport::Concern

  included do
    has_many :orders, as: :orderer
    has_many :shipping_addresses, class_name: "Order::ShippingAddress", through: :orders, source: :shipping_address
  end
end
