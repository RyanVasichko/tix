class User < ApplicationRecord
  include Stripeable, Shopper, CanBeDeactivated, Searchable

  has_secure_password validations: false

  orderable_by :email

  STRIP_SPECIAL_CHARACTERS_FROM_PHONE_SQL = "REPLACE(REPLACE(REPLACE(REPLACE(phone, '-', ''), '(', ''), ')', ''), ' ', '')"
  scope :keyword_search, ->(keyword) {
    where(<<-SQL, keyword: "%#{keyword}%")
        CONCAT(first_name, ' ', last_name) LIKE :keyword OR
        email LIKE :keyword OR
        #{STRIP_SPECIAL_CHARACTERS_FROM_PHONE_SQL} LIKE :keyword
    SQL
  }

  scope :order_by_name, ->(direction = :asc) {
    order(Arel.sql("LOWER(CONCAT(first_name, ' ', last_name)) COLLATE NOCASE #{direction}"))
  }

  scope :order_by_phone, ->(direction = :asc) {
    order(Arel.sql("#{STRIP_SPECIAL_CHARACTERS_FROM_PHONE_SQL} COLLATE NOCASE #{direction}"))
  }

  def can?(perform_action)
    false
  end

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
