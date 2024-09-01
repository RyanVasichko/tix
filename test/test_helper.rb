ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "mocha/minitest"
require "webmock/minitest"
require_relative "../lib/faker/seating_chart"
require_relative "../db/migrate/20240313033609_create_order_search_indices"

WebMock.enable!

class ActiveSupport::TestCase
  include ActiveJob::TestHelper

  parallelize(workers: :number_of_processors)

  Time::DATE_FORMATS[:datetime_field] = "%m%d%Y\t%I%M%P"
  Time::DATE_FORMATS[:time_field] = "%I:%M%P"
  Time::DATE_FORMATS[:date_field] = "%m/%d/%Y"

  setup do
    Faker::UniqueGenerator.clear

    # HACK: Rails doesn't play nicely with SQLite FTS indexes.
    # There's probably a better way to do this, but for now I'm just running the migration
    # to create the index before each test. I can't run it before the whole suite because
    # Rails creates a bunch of test databases to run tests in parallel.
    ActiveRecord::Migration.verbose = false
    CreateOrderSearchIndices.migrate(:up)
  end
end

class ActionDispatch::IntegrationTest
  include SessionTestHelper
end
