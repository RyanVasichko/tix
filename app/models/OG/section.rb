module OG
  class Section < Record
    belongs_to :seating_chart, inverse_of: :sections, class_name: 'OG::SeatingChart'
    has_many :seats, inverse_of: :section, class_name: 'OG::Seat'
    belongs_to :ticket_type, class_name: 'OG::TicketType'
  end
end
