ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "mocha/minitest"
require "webmock/minitest"
require_relative "../lib/faker/seating_chart"
require_relative "test_helpers/session_test_helper"

WebMock.enable!

class ActiveSupport::TestCase
  include ActiveJob::TestHelper

  parallelize(workers: :number_of_processors)

  Time::DATE_FORMATS[:datetime_field] = "%m%d%Y\t%I%M%P"
  Time::DATE_FORMATS[:time_field] = "%I:%M%P"
  Time::DATE_FORMATS[:date_field] = "%m/%d/%Y"

  setup do
    Faker::UniqueGenerator.clear
  end
end

class ActionDispatch::IntegrationTest
  include SessionTestHelper
end
