require "test_helper"
require "support/draggable"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Draggable, ActionMailer::TestHelper

  setup do
    WebMock.enable_net_connect!
  end

  teardown do
    WebMock.reset!
  end

  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

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
end
