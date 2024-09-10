class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.random(limit = 1)
    self.where(id: self.select(:id).order("RANDOM()").limit(limit))
  end
end
