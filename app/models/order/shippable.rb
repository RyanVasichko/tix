module Order::Shippable
  extend ActiveSupport::Concern

  included do
    belongs_to :shipping_address, class_name: "Order::ShippingAddress", inverse_of: :order, optional: true
    validates :shipping_address, presence: true, if: -> { merch.any? }
    accepts_nested_attributes_for :shipping_address
  end
end
