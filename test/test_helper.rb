ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "mocha/minitest"
require "webmock/minitest"
require_relative "../lib/faker/seating_chart"

WebMock.enable!

Bullet.enable = ENV["ENABLE_BULLET"] == "1"
Bullet.bullet_logger = true
Bullet.unused_eager_loading_enable = false
Bullet.raise = true # raise an error if n+1 query occurs

class ActiveSupport::TestCase
  include ActiveJob::TestHelper # Used for perform_enqueued_jobs

  parallelize(workers: :number_of_processors)

  Time::DATE_FORMATS[:datetime_field] = "%m%d%Y\t%I%M%P"
  Time::DATE_FORMATS[:time_field] = "%I:%M%P"
  Time::DATE_FORMATS[:date_field] = "%m/%d/%Y"

  setup do
    Faker::UniqueGenerator.clear
    Bullet.start_request if Bullet.enable?
  end

  teardown do
    if Bullet.enabled?
      Bullet.perform_out_of_channel_notifications if Bullet.notification?
      Bullet.end_request
    end
  end
end

class ActionDispatch::IntegrationTest
  include SessionTestHelper
end
