ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  include ActiveJob::TestHelper # Used for perform_enqueued_jobs

  # parallelize(workers: :number_of_processors)

  Time::DATE_FORMATS[:datetime_field] = "%m%d%Y\t%I%M%P"
  Time::DATE_FORMATS[:time_field] = "%I:%M%P"
  Time::DATE_FORMATS[:date_field] = "%m/%d/%Y"

  setup do
    Faker::UniqueGenerator.clear
  end
end
