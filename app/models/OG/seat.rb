module OG
  class Seat < Record
    belongs_to :section, inverse_of: :seats, class_name: 'OG::Section'
  end
end
