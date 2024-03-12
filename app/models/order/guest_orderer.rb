class Order::GuestOrderer < ApplicationRecord
  has_many :orders, as: :orderer
  before_validation :set_shopper_uuid, on: :create, unless: -> { shopper_uuid.present? }

  def name
    "#{first_name} #{last_name}"
  end

  def stripe_customer
    nil
  end

  private

  def set_shopper_uuid
    self.shopper_uuid = SecureRandom.uuid
  end
end
