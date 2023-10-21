class User::Guest < User
  after_create_commit -> { DestroyGuestUserJob.set(wait: 1.week).perform_later(id) }
  has_many :guest_orderers, class_name: "Order::GuestOrderer", foreign_key: :shopper_uuid, primary_key: :shopper_uuid
  has_many :orders, through: :guest_orderers, class_name: "Order"
  has_many :shipping_addresses, class_name: "Order::ShippingAddress", through: :orders, source: :shipping_address

  def order_form_type
    Order::GuestOrderForm
  end

  def guest?
    true
  end

  def transfer_shopping_cart_to(user)
    shopping_cart.transfer_to(user)
  end

  def destroy_later
    DestroyGuestUserJob.perform_later(id)
  end
end
