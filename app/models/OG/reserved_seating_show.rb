module OG
  class ReservedSeatingShow < Show
    belongs_to :seating_chart, class_name: 'OG::SeatingChart', foreign_key: :seating_chart_id
    has_many :sections, class_name: 'OG::ReservedSeatingShowSection', foreign_key: :show_id, dependent: :destroy, inverse_of: :show

    def self.sti_name
      "ReservedSeatingShow"
    end
  end
end
