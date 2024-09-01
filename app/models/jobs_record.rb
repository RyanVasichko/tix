class JobsRecord < ActiveRecord::Base
  self.abstract_class = true
  connects_to database: { writing: :jobs }
end
