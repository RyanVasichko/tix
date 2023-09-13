class User < ApplicationRecord
  has_secure_password

  has_many :reserved_seats, class_name: "Show::Seat", inverse_of: :reserved_by, foreign_key: "reserved_by_id"
  
  validates :first_name, :last_name, :email, presence: true, unless: :guest?
  validates :email, uniqueness: true

  attribute :guest, default: false
  attribute :admin, default: false
end