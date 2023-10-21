class Show::Section < ApplicationRecord
  attr_accessor :seating_chart_section_id

  belongs_to :show, inverse_of: :sections, touch: true
  has_many :seats, class_name: "Show::Seat", inverse_of: :section, foreign_key: "show_section_id" do
    def build_from_seating_chart_seat(seating_chart_seat)
      build(
        x: seating_chart_seat.x,
        y: seating_chart_seat.y,
        seat_number: seating_chart_seat.seat_number,
        table_number: seating_chart_seat.table_number
      )
    end
  end

  validates :ticket_price, presence: true

  after_initialize :build_seats, if: -> { seating_chart_section_id && new_record? }
  after_initialize :set_name_from_seating_chart_section, if: :seating_chart_section_id

  private

  def build_seats
    seating_chart_section = SeatingChart::Section.includes(:seats).find(seating_chart_section_id)
    seating_chart_section.seats.each do |seating_chart_seat|
      seats.build_from_seating_chart_seat(seating_chart_seat)
    end
  end

  def set_name_from_seating_chart_section
    self.name = SeatingChart::Section.find(seating_chart_section_id).name
  end
end
