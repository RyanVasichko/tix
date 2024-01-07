class Order::GuestOrderer < ApplicationRecord
  has_many :orders, as: :orderer, class_name: "Order::Order"

  def full_name
    "#{first_name} #{last_name}"
  end

  def stripe_customer
    nil
  end
end
