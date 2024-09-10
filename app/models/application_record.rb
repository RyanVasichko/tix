class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.random(limit = 1)
    return none if !self.any?

    min_id = self.minimum(:id)
    max_id = self.maximum(:id)

    random_ids = []
    while random_ids.size < limit
      random_id = rand(min_id..max_id)
      random_ids << random_id if self.exists?(random_id)
    end

    self.where(id: random_ids)
  end
end
