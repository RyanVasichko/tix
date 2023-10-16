class Artist < ApplicationRecord
  include Deactivatable

  has_one_attached :image
  has_many :shows

  validates :name, presence: true, uniqueness: true
end
