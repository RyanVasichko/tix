module OG
  class Record < ActiveRecord::Base
    self.abstract_class = true
    connects_to database: { writing: :og, reading: :og }
  end
end
