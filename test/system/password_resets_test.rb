require "application_system_test_case"

class PasswordResetsTest < ApplicationSystemTestCase
  test "requesting a password reset" do
    customer = FactoryBot.create(:customer)

    visit new_user_session_path
    click_on "Forgot password?"

    fill_in "Email", with: customer.email
    click_on "Send me reset password instructions"
    assert_text "If you have an account an email has been sent with instructions for resetting your password."
    assert_enqueued_email_with UserMailer, :password_reset_email, args: customer
  end

  test "resetting a password" do
    customer = FactoryBot.create(:customer)
    visit edit_user_password_reset_url(reset_password_token: customer.password_reset_token)
    fill_in "New password", with: "NewPassword"
    fill_in "Confirm new password", with: "NewPassword"
    click_on "Reset my password"
    assert_text "Your password has been successfully reset."

    assert customer.reload.authenticate("NewPassword")
  end
end
