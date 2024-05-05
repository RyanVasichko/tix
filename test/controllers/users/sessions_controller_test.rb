require "test_helper"

class Users::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = FactoryBot.create(:customer) }

  test "should get new if not logged in" do
    get new_user_session_url
    assert_response :success
  end

  test "should redirect to root if already logged in" do
    sign_in @user
    get new_user_session_url
    assert_redirected_to root_url
    assert_equal "You are already signed in.", flash[:alert]
  end

  test "should log in with valid credentials" do
    post new_user_session_url, params: { session: { email: @user.email, password: "Radiohead" } }
    assert_redirected_to root_url
    follow_redirect!
  end

  test "shouldn't log in with invalid credentials" do
    post new_user_session_url, params: { session: { email: @user.email, password: "wrongpassword" } }
    assert_response :unauthorized
    assert_includes response.body, "Invalid email or password"
  end

  test "should log out" do
    sign_in @user
    delete destroy_user_session_path
    assert_redirected_to root_url
    follow_redirect!
    assert_includes response.body, "You have been signed out successfully."
    assert_not_includes response.body, @user.name
    assert_includes response.body, "Sign In"
  end

  test "should transfer seat reservations from a guest to the logged in user" do
    show = FactoryBot.create(:reserved_seating_show)

    get root_url
    guest = Users::Guest.last

    seat = show.seats.available.first
    seat.ticket.select_for!(guest)

    sign_in @user

    assert_equal @user, seat.reload_selected_by
  end
end
