class Order::ShippingAddress < ApplicationRecord
  has_one :order, inverse_of: :shipping_address

  belongs_to :address
  delegate :address_1, :address_2, :city, :state, :zip_code, to: :address
  delegate :address_1=, :address_2=, :city=, :state=, :zip_code=, to: :address
  accepts_nested_attributes_for :address

  validates :first_name, presence: true
  validates :last_name, presence: true

  after_initialize { self.address ||= Address.new }

  scope :order_by_recent_usage, -> { joins(:order).order("orders.created_at DESC") }
end
