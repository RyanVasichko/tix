require 'test_helper'
require 'support/draggable'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Draggable

  driven_by :selenium, using: :chrome, screen_size: [1920, 1080], options: {
    browser: :remote,
    url: 'http://selenium:4444'
  }
  
  Capybara.server_host = '0.0.0.0'
  Capybara.app_host = "http://#{ENV.fetch('HOSTNAME')}:#{Capybara.server_port}"


  teardown do
    logs = page.driver.browser.logs.get(:browser)
    error_logs = logs.select { |e| e.level == 'SEVERE' }

    error_logs.each do |log|
      puts "[ERROR - #{log.timestamp}] #{log.message}"
    end

    assert error_logs.empty?, 'Console errors were detected. See the logs for more information.'
  end
end