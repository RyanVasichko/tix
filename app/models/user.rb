class User < ApplicationRecord
  include Stripeable, Shopper, KeywordSearchable

  has_secure_password validations: false

  def can?(perform_action)
    false
  end

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
