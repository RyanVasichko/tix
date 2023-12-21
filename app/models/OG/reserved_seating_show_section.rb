module OG
  class ReservedSeatingShowSection < ShowSection
    belongs_to :show, class_name: 'OG::ReservedSeatingShow', foreign_key: :show_id, inverse_of: :sections
    has_many :tickets, class_name: "OG::Ticket", foreign_key: :show_section_id
    def self.sti_name
      "ReservedSeatingShowSection"
    end
  end
end
