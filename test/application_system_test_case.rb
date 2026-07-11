require "test_helper"
require "support/draggable"
require "support/playwright_setup"
require "capybara-playwright-driver"

PlaywrightTestSetup.verify! unless ENV["PLAYWRIGHT_PREFLIGHT_CHECKED"] == "1"
ENV["PLAYWRIGHT_PREFLIGHT_CHECKED"] = "1"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Draggable, ActionMailer::TestHelper

  setup do
    WebMock.enable_net_connect!
  end

  teardown do
    WebMock.reset!
  end

  driven_by :playwright,
    screen_size: [1400, 1400],
    options: {
      browser_type: :chromium,
      headless: true,
      playwright_cli_executable_path: ENV.fetch(
        "PLAYWRIGHT_CLI_EXECUTABLE_PATH",
        "npx --yes playwright@#{Playwright::COMPATIBLE_PLAYWRIGHT_VERSION}"
      )
    }

  def sign_in(user, password = "Radiohead")
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: password
    click_on "Sign In"
    assert_text "You have been signed in successfully."
  end

  def dismiss_all_toast_messages
    all(".toast_dismiss").each(&:click)
  end

  def open_shopping_cart
    find("#shopping_cart_toggle").click
    return if has_selector?("#shopping_cart_items", wait: 5)

    find("#shopping_cart_toggle").click
    assert_selector "#shopping_cart_items", wait: 10
  end
end
