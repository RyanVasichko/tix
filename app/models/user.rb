class User < ApplicationRecord
  include Stripeable, Shopper, Orderer, CanBeDeactivated, Searches, Searchable

  has_secure_password
  has_many :sessions, class_name: "User::Session", dependent: :destroy

  scope :customer_or_admin, -> { where(type: %w[Users::Customer Users::Admin]) }

  before_create -> { self.last_active_at = Time.current }

  def name
    "#{first_name} #{last_name}"
  end

  def guest?
    false
  end

  def customer?
    false
  end

  def admin?
    false
  end
end
