module OG
  class GeneralAdmissionShowSection < ShowSection
    belongs_to :show, class_name: "OG::GeneralAdmissionShow", foreign_key: "show_id", inverse_of: :sections

    def self.sti_name
      "GeneralAdmissionShowSection"
    end
  end
end
