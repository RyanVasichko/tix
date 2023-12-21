class Venue < ApplicationRecord
  include Deactivatable

  validates :name, presence: true, uniqueness: true
  has_many :seating_charts
  has_many :ticket_types
  belongs_to :address, optional: true
  has_one_attached :image
end
