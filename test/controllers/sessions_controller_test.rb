require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:larry_sellers)
  end

  test "should get new" do
    get login_path
    assert_response :success
  end

  test "should log in with valid information" do
    post login_path, params: { session: { email: @user.email, password: 'password' } }
    assert_redirected_to root_path
    follow_redirect!
    assert Current.user = @user
  end

  test "should not log in with invalid information" do
    post login_path, params: { session: { email: @user.email, password: 'wrong_password' } }
    assert Current.user.nil?
  end

  test "should log out" do
    Current.user = @user
    
    delete logout_path
    assert_redirected_to root_url
    follow_redirect!

    assert Current.user.nil?
  end
end
