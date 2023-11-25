class Show::Section < ApplicationRecord
  attr_accessor :seating_chart_section_id

  enum payment_method: TicketType::PAYMENT_METHODS
  enum convenience_fee_type: TicketType::CONVENIENCE_FEE_TYPES

  belongs_to :show, inverse_of: :sections, touch: true
  has_many :seats, class_name: "Show::Seat", inverse_of: :section, foreign_key: "show_section_id"

  validates :ticket_price, presence: true

  after_initialize :build_seats, if: -> { seating_chart_section_id && new_record? }
  after_initialize :set_name_from_seating_chart_section, if: -> { seating_chart_section_id && new_record? }
  after_initialize :set_ticket_type_fields, if: -> { seating_chart_section_id && new_record? }

  def seat_convenience_fees
    if convenience_fee_type == "flat_rate"
      convenience_fee
    elsif convenience_fee_type == "percentage"
      ((ticket_price * convenience_fee) / 100).round(2)
    end
  end

  private

  def build_seats
    seating_chart_section = SeatingChart::Section.includes(:seats).find(seating_chart_section_id)
    seating_chart_section.seats.each do |seating_chart_seat|
      seats << Show::Seat.build_from_seating_chart_seat(seating_chart_seat)
    end
  end

  def set_name_from_seating_chart_section
    self.name = SeatingChart::Section.find(seating_chart_section_id).name
  end

  def set_ticket_type_fields
    ticket_type = SeatingChart::Section.find(seating_chart_section_id).ticket_type
    self.payment_method = ticket_type.payment_method
    self.convenience_fee_type = ticket_type.convenience_fee_type
    self.convenience_fee = ticket_type.convenience_fee
    self.venue_commission = ticket_type.venue_commission
  end
end
