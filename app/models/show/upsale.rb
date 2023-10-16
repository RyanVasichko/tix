class Show::Upsale < ApplicationRecord
  include Deactivatable

  belongs_to :show

  validates :name, presence: true, uniqueness: { scope: :show_id }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
