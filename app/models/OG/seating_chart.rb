module OG
  class SeatingChart < Record
    has_attached_file :chart_image, {
      path: "/seating_charts/:attachment/:id_partition/:style/:filename"
    }

    has_many :sections, inverse_of: :seating_chart, class_name: 'OG::Section'
    has_many :seats, through: :sections, class_name: 'OG::Seat'
  end
end
