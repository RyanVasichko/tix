module OG
  class Ticket < Record
    belongs_to :show_section, class_name: 'OG::ShowSection', foreign_key: 'show_section_id'
    belongs_to :seat, class_name: 'OG::Seat', foreign_key: 'seat_id'
  end
end
