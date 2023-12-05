require "application_system_test_case"

class SignInTest < ApplicationSystemTestCase
  def setup
    @user = FactoryBot.create(:customer)
  end

  test "signing in with valid information" do
    visit login_path

    assert_selector "h2", text: "Sign In"

    fill_in "session[email]", with: @user.email
    fill_in "session[password]", with: "password"
    click_button "Sign In"

    assert_text "Upcoming Shows"
  end

  test "signing in with invalid information" do
    visit login_path

    fill_in "session[email]", with: "nonexistent@example.com"
    fill_in "session[password]", with: "wrongpassword"
    click_button "Sign In"

    assert_selector "h2", text: "Sign In"
    assert_text "Invalid email/password combination"
  end
end
