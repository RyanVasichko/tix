class Merch::ShippingCharge < ApplicationRecord
  validates :weight, presence: true, uniqueness: true
  validates :price, presence: true

  def self.for_weight(weight)
    where(weight: weight..).order(weight: :asc).limit(1).pluck(:price).first || maximum(:price)
  end
end
