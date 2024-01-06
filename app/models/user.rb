class User < ApplicationRecord
  include Stripeable, Shopper

  has_secure_password validations: false

  scope :keyword_search, ->(keyword) {
    where(<<-SQL, keyword: "%#{keyword}%")
      CONCAT(first_name, ' ', last_name) LIKE :keyword OR
      email LIKE :keyword OR
      REPLACE(REPLACE(REPLACE(REPLACE(phone, '-', ''), '(', ''), ')', ''), ' ', '') LIKE :keyword
    SQL
  }

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
