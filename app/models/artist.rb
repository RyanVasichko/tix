class Artist < ApplicationRecord
  include CanBeDeactivated, Searchable

  orderable_by :name

  scope :keyword_search, ->(keyword) { where("name LIKE ?", "%#{keyword}%") }

  has_one_attached :image do |image|
    image.variant :small, resize_to_limit: [300, 300], format: :webp, convert: :webp, preprocessed: true
    image.variant :medium, resize_to_limit: [600, 600], format: :webp, convert: :webp, preprocessed: true
  end
  has_many :shows

  validates :name, presence: true, uniqueness: { case_sensitive: false, conditions: -> { where(active: true) } }
end
