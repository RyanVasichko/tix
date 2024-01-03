class Show::ReservedSeatingSection < Show::Section
  attr_accessor :seating_chart_section_id

  after_initialize :set_fields_from_seating_chart_section, if: -> { seating_chart_section_id && new_record? }

  private

  def set_fields_from_seating_chart_section
    set_name_from_seating_chart_section
    set_ticket_type_fields
    build_seats
  end

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
