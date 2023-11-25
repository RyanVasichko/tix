class TicketType < ApplicationRecord
  include Deactivatable

  belongs_to :venue

  PAYMENT_METHODS = { deposit: 0, cover: 1 }.freeze
  enum payment_method: PAYMENT_METHODS

  CONVENIENCE_FEE_TYPES = { flat_rate: 0, percentage: 1 }.freeze
  enum convenience_fee_type: CONVENIENCE_FEE_TYPES

  validates :name, presence: true, uniqueness: { scope: :venue_id }
  validates :convenience_fee, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :convenience_fee_type, presence: true
  validates :default_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :venue_commission, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :dinner_included, inclusion: { in: [true, false] }
  validates :active, inclusion: { in: [true, false] }
  validates :payment_method, presence: true
end
