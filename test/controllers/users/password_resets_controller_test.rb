require "test_helper"

class Users::PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  test "should get new if the user is note authenticated" do
    get new_user_password_reset_url
    assert_response :success
  end

  test "should not get new if the user is authenticated" do
    sign_in FactoryBot.create(:customer)
    get new_user_password_reset_url
    assert_response :redirect
    follow_redirect!
    assert_includes response.body, "You are already signed in."
  end

  test "create should send an email with password reset instructions" do
    customer = FactoryBot.create(:customer)

    post user_password_reset_url, params: { user: { email: customer.email } }
    assert_response :redirect
    assert_enqueued_email_with UserMailer, :password_reset_email, args: customer
  end

  test "create should redirect back if the user is authenticated" do
    sign_in FactoryBot.create(:customer)
    post user_password_reset_url, params: { user: { email: "some_email@test.com" } }
    assert_response :redirect
    follow_redirect!
    assert_includes response.body, "You are already signed in."
  end

  test "new should get edit for a valid reset token" do
    customer = FactoryBot.create(:customer)

    get edit_user_password_reset_url(reset_password_token: customer.password_reset_token)
    assert_response :success
  end

  test "new should redirect to the password reset form for an expired reset token" do
    customer = FactoryBot.create(:customer)
    reset_token = customer.password_reset_token

    travel_to 7.hours.from_now do
      get edit_user_password_reset_url(reset_password_token: reset_token)
      assert_redirected_to new_user_password_reset_url
      follow_redirect!
      assert_includes response.body, "Your reset token has expired. Please try again."
    end
  end

  test "new should redirect to the password reset form for an invalid reset token" do
    get edit_user_password_reset_url(reset_password_token: "fake_token")
    assert_redirected_to new_user_password_reset_url
    follow_redirect!
    assert_includes response.body, "Your reset token has expired. Please try again."
  end

  test "update should reset the user's password for a valid reset token" do
    customer = FactoryBot.create(:customer)
    patch user_password_reset_path, params: {
      reset_password_token: customer.password_reset_token,
      password: "ThisIsANewPassword",
      password_confirmation: "ThisIsANewPassword"
    }
    assert_redirected_to root_url

    assert customer.reload.authenticate "ThisIsANewPassword"
  end

  test "update should not update a password when the confirmation does not match" do
    customer = FactoryBot.create(:customer)
    patch user_password_reset_path, params: {
      reset_password_token: customer.password_reset_token,
      password: "ThisIsANewPassword",
      password_confirmation: "ThisDoesNotMatch"
    }
    assert_response :unprocessable_entity
  end

  test "update should not update a password when the token is expired" do
    customer = FactoryBot.create(:customer)
    reset_token = customer.password_reset_token

    travel_to 7.hours.from_now do
      patch user_password_reset_path, params: {
        reset_password_token: reset_token,
        password: "ThisIsANewPassword",
        password_confirmation: "ThisIsANewPassword"
      }
    end
    assert_redirected_to new_user_password_reset_url
    follow_redirect!
    assert_includes response.body, "Your reset token has expired. Please try again."
  end
end
