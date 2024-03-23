class Show::Sections::ReservedSeating < Show::Section
  attr_accessor :seating_chart_section_id
  after_initialize :build_from_seating_chart_section, if: -> { seating_chart_section_id && new_record? }

  has_many :tickets, class_name: "Tickets::ReservedSeating", inverse_of: :show_section
  has_many :seats, class_name: "Show::Seat", through: :tickets

  private

  def build_from_seating_chart_section
    seating_chart_section = SeatingChart::Section.find(seating_chart_section_id)

    self.name = seating_chart_section.name
    set_ticket_type_fields_from_section(seating_chart_section)
    build_seats_from_seating_chart_section(seating_chart_section)
  end

  def build_seats_from_seating_chart_section(seating_chart_section)
    seating_chart_section.seats.each do |seating_chart_seat|
      tickets << Tickets::ReservedSeating.new(seat: Show::Seat.build_from_seating_chart_seat(seating_chart_seat))
    end
  end

  def set_ticket_type_fields_from_section(seating_chart_section)
    ticket_type = seating_chart_section.ticket_type

    self.payment_method = ticket_type.payment_method
    self.convenience_fee_type = ticket_type.convenience_fee_type
    self.convenience_fee = ticket_type.convenience_fee
    self.venue_commission = ticket_type.venue_commission
  end
end
