class Venue < ApplicationRecord
  include CanBeDeactivated, Searchable

  has_many :seating_charts
  has_many :ticket_types
  belongs_to :address, optional: true
  has_one_attached :image

  validates :name, presence: true, uniqueness: true

  orderable_by :name, :active

  scope :keyword_search, ->(query) { where("name ILIKE ?", "%#{query}%") }
end
