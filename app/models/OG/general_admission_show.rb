module OG
  class GeneralAdmissionShow < Show
    has_many :sections, class_name: "GeneralAdmissionShowSection", foreign_key: "show_id", inverse_of: :show, dependent: :destroy

    def self.sti_name
      "GeneralAdmissionShow"
    end
  end
end
