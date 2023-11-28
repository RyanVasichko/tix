class Venue < ApplicationRecord
  include Deactivatable

  validates :name, presence: true, uniqueness: true
  has_many :seating_charts
  has_many :ticket_types
end