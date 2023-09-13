class SeatingChart::Seat < ApplicationRecord
  belongs_to :section,
             inverse_of: :seats,
             class_name: "SeatingChart::Section",
             foreign_key: "seating_chart_section_id"

  alias_attribute :section_id, :seating_chart_section_id

  validates :x, presence: true
  validates :y, presence: true
  validates :seat_number, presence: true
  validates :table_number, presence: true
  validates :section, presence: true
end
