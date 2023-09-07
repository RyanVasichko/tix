class User < ApplicationRecord
  has_secure_password
  
  validates :first_name, :last_name, :email, presence: true, unless: :guest?
  validates :email, uniqueness: true

  attribute :guest, default: false
  attribute :admin, default: false
end