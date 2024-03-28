class Users::Guest < User
  has_many :guest_orderers, class_name: "Order::GuestOrderer", foreign_key: :shopper_uuid, primary_key: :shopper_uuid
  has_many :orders, through: :guest_orderers, class_name: "Order"
  has_many :shipping_addresses, class_name: "Order::ShippingAddress", through: :orders, source: :shipping_address

  def name
    "Guest"
  end

  def guest?
    true
  end
end
