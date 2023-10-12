class Order::ShippingAddress < ApplicationRecord
  has_one :order, inverse_of: :shipping_address

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :postal_code, presence: true
end
