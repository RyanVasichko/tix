class User < ApplicationRecord
  include Stripeable, Shopper, Orderer, CanBeDeactivated, Searches, Searchable

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
