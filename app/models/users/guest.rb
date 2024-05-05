class Users::Guest < User
  has_many :guest_orderers, class_name: "Order::GuestOrderer", foreign_key: :shopper_uuid, primary_key: :shopper_uuid
  has_many :orders, through: :guest_orderers, class_name: "Order"
  has_many :shipping_addresses, class_name: "Order::ShippingAddress", through: :orders, source: :shipping_address

  def errors
    super.tap { |errors| errors.delete(:password, :blank) }
  end

  def email_required?
    false
  end

  def password_required?
    false
  end

  def name
    "Guest"
  end

  def guest?
    true
  end
end
