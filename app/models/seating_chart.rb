class SeatingChart < ApplicationRecord
  include CanBeDeactivated, Searchable, Copyable

  has_one_attached :venue_layout
  has_many :sections, dependent: :destroy, class_name: "SeatingChart::Section", inverse_of: :seating_chart
  has_many :seats, through: :sections, source: :seats
  belongs_to :venue

  accepts_nested_attributes_for :sections, allow_destroy: true

  validates :name, presence: true, uniqueness: { case_sensitive: false, conditions: -> { where(active: true) } }
  validates :venue_layout, presence: true, if: -> { published? && active? }

  orderable_by :name

  scope :keyword_search, ->(query) { where("name LIKE ?", "%#{query}%") }
end
