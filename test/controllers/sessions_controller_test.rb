require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = FactoryBot.create(:customer) }

  test "should get new if not logged in" do
    get login_url
    assert_response :success
  end

  test "should redirect to root if already logged in" do
    sign_in @user
    get login_url
    assert_redirected_to root_url
    assert_equal "You are already logged in!", flash[:notice]
  end

  test "should log in with valid credentials" do
    post login_url, params: { session: { email: @user.email, password: "Radiohead" } }
    assert_redirected_to root_url
    follow_redirect!
  end

  test "shouldn't log in with invalid credentials" do
    post login_url, params: { session: { email: @user.email, password: "wrongpassword" } }
    assert_response :unprocessable_entity
    assert flash[:error], "Invalid email/password combination"
    assert User.find(session[:user_id]).guest?
  end

  test "should log out" do
    sign_in @user
    delete logout_url
    assert_redirected_to root_url
    assert_nil session[:user_id]
    follow_redirect!
  end

  test "should transfer seat reservations from a guest to the logged in user" do
    show = FactoryBot.create(:reserved_seating_show)

    get login_path # Just get a random endpoint so it will create the guest user
    guest = Users::Guest.last

    seat = show.seats.where(shopping_cart: nil, reserved_until: nil).first
    seat.reserve_for(guest)

    sign_in @user

    seat.reload
    assert_equal @user, seat.reserved_by

    perform_enqueued_jobs

    assert_not User.exists?(id: guest.id)
  end
end
