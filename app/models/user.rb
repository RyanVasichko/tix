class User < ApplicationRecord
  include Stripeable, Shopper

  has_secure_password validations: false

  def full_name
    "#{first_name} #{last_name}"
  end
end
