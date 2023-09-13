class SeatingChart::Section < ApplicationRecord
  belongs_to :seating_chart, inverse_of: :sections

  has_many :seats,
           inverse_of: :section,
           dependent: :destroy,
           class_name: "SeatingChart::Seat",
           foreign_key: "seating_chart_section_id"
  accepts_nested_attributes_for :seats, allow_destroy: true

  validates :name, presence: true
  validates :seats, length: { minimum: 1, message: "must have at least 1 seat" }
end
