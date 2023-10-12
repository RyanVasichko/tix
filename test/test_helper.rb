ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  include ActiveJob::TestHelper # Used for perform_enqueued_jobs

  # parallelize(workers: :number_of_processors)

  fixtures :all
end
