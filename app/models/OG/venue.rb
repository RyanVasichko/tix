module OG
  class Venue < Record
    belongs_to :address, optional: false
  end
end
