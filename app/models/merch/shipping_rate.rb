class Merch::ShippingRate < ApplicationRecord
  validates :weight, presence: true, uniqueness: true
  validates :price, presence: true

  def self.for_purchases(merch_purchases)
    return 0 if merch_purchases.empty?

    weight = merch_purchases.sum { |s| s.quantity * s.merch.weight }
    where(weight: weight..).order(weight: :asc).limit(1).pluck(:price).first || maximum(:price) || 0
  end
end
