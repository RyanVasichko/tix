class Artist < ApplicationRecord
  include Deactivatable

  has_one_attached :image do |image|
    image.variant :medium, resize_to_limit: [600, 600], format: :webp, convert: :webp
  end
  has_many :shows

  validates :name, presence: true, uniqueness: true
end
