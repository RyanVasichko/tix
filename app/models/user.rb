class User < ApplicationRecord
  include Stripeable, Shopper

  has_secure_password validations: false

  def full_name
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
