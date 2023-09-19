class User < ApplicationRecord
  include Stripeable, Reserver

  has_secure_password validations: false

  has_many :orders

  def ticket_reservation_time
    15.minutes
  end

  def shopping_cart
    @shopping_cart ||= ShoppingCart.new(self)
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
