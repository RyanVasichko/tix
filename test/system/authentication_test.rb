require "application_system_test_case"

class AuthenticationTest < ApplicationSystemTestCase
  test "signing in with valid information" do
    user = FactoryBot.create(:customer)
    visit new_user_session_url

    assert_selector "h2", text: "Sign In"

    fill_in "Email", with: user.email
    fill_in "Password", with: "Radiohead"
    click_button "Sign In"

    assert_text "Upcoming Shows"
  end

  test "signing in with invalid information" do
    visit new_user_session_url

    fill_in "Email", with: "nonexistent@example.com"
    fill_in "Password", with: "wrongpassword"
    click_button "Sign In"

    assert_selector "h2", text: "Sign In"
    assert_text "Invalid email or password."
  end

  test "signing up" do
    visit new_user_path

    fill_in "Email", with: "thom.yorke@radiohead.com"
    find("input[name='user[password]']").set("Radiohead")
    fill_in "Password confirmation", with: "Radiohead"
    fill_in "First name", with: "Thom"
    fill_in "Last name", with: "Yorke"
    fill_in "Phone", with: "555-555-5555"
    assert_difference -> { Users::Customer.count } => 1 do
      click_on "Sign up"
      assert_text "Your account has been successfully created."
    end

    thom = Users::Customer.find_by! email: "thom.yorke@radiohead.com",
                                    first_name: "Thom",
                                    last_name: "Yorke",
                                    phone: "555-555-5555"
    assert thom.authenticate("Radiohead")
  end

  test "resetting my password" do
    user = FactoryBot.create(:customer)
    visit edit_user_password_reset_url(reset_password_token: user.password_reset_token)
    fill_in "New password", with: "NewPassword"
    fill_in "Confirm new password", with: "NewPassword"
    click_on "Reset my password"
    assert_text "Your password has been successfully reset."

    assert user.reload.authenticate("NewPassword")
  end
end
