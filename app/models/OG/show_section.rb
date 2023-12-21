module OG
  class ShowSection < Record
    belongs_to :section, class_name: 'OG::Section', foreign_key: 'section_id'

    def self.find_sti_class(type_name)
      case type_name
      when "ReservedSeatingShowSection"
        OG::ReservedSeatingShowSection
      when 'GeneralAdmissionShowSection'
        OG::GeneralAdmissionShowSection
      else
        super
      end
    end
  end
end
