class User < ApplicationRecord
  include Stripeable, Shopper, Orderer, CanBeDeactivated, Searches, Searchable

  before_create -> { self.last_active_at = Time.current }

  has_secure_password validations: false

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
