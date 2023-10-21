class Order::GuestOrderer < ApplicationRecord
  has_many :orders, as: :orderer, class_name: 'Order::Order'

  def stripe_customer
    nil
  end
end
