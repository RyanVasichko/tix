class Order::GuestOrderer < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

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
