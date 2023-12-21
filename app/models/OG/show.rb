module OG
  class Show < Record
    belongs_to :artist, class_name: 'OG::Artist', foreign_key: 'artist_id'

    def self.find_sti_class(type_name)
      case type_name
      when "ReservedSeatingShow"
        OG::ReservedSeatingShow
      when 'GeneralAdmissionShow'
        OG::GeneralAdmissionShow
      else
        super
      end
    end
  end
end
