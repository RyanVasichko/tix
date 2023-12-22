class Merch::ShippingCharge < ApplicationRecord
  validates :weight, presence: true, uniqueness: true
  validates :price, presence: true
end
