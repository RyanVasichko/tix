class Show::Section < ApplicationRecord
  belongs_to :show, inverse_of: :sections, touch: true
  has_many :seats, class_name: "Show::Seat", inverse_of: :section, foreign_key: "show_section_id"
  belongs_to :seating_chart_section, class_name: "SeatingChart::Section"
  has_many :seating_chart_seats, class_name: "SeatingChart::Seat", through: :seating_chart_section

  validates :ticket_price, presence: true

  before_create :build_seats

  private

  def build_seats
    seating_chart_section.seats.each do |seat|
      seats << Show::Seat.build_from_seating_chart_seat(seat)
    end
  end
end
