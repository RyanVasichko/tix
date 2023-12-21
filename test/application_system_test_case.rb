require "test_helper"
require "support/draggable"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Draggable

  Capybara.server = :puma, { Silent: true }

  if ENV.fetch("DOCKERIZED") { false }
    driven_by :selenium, using: :chrome, screen_size: [1920, 1080], options: {
      browser: :remote,
      url: "http://selenium:4444"
    }

    Capybara.server_host = "0.0.0.0"
    Capybara.app_host = "http://#{ENV.fetch("HOSTNAME")}:#{Capybara.server_port}"
  else
    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  end

  teardown do
    if defined?(page.driver.browser.logs)
      logs = page.driver.browser.logs.get(:browser)
      error_logs = logs.select { |e| e.level == "SEVERE" }.filter { |e| !e.message.include?("Failed to fetch") }

      error_logs.each do |log|
        puts ""
        puts "[CONSOLE ERROR - #{log.timestamp}] #{log.message}"
      end
    end
  end

  def log_in_as(user, password = "password")
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: password
    click_on "Sign In"

    assert_text "Welcome back, #{user.full_name}!"

    all(".dismiss_flash_message").each(&:click)
  end
end
