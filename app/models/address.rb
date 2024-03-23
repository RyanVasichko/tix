class Address < ApplicationRecord
  validates :address_1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true
end
