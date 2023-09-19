require "application_integration_test_case"

class SessionsControllerTest < ApplicationIntegrationTestCase
  setup { @larry_sellers = users(:larry_sellers) }

  test "should get new if not logged in" do
    get login_url
    assert_response :success
  end

  test "should redirect to root if already logged in" do
    log_in_as(@larry_sellers, "password")
    get login_url
    assert_redirected_to root_url
    assert_equal "You are already logged in!", flash[:notice]
  end

  test "should log in with valid credentials" do
    post login_url, params: { session: { email: @larry_sellers.email, password: 'password' } }
    assert_redirected_to root_url
    follow_redirect!

    skip "need some UI indication that they're logged in"
    # Check for some indication that user is logged in (maybe a flash message or some content change)
    assert_select "a[href=?]", logout_path
  end

  test "shouldn't log in with invalid credentials" do
    post login_url, params: { session: { email: @larry_sellers.email, password: 'wrongpassword' } }
    assert_response :success
    assert flash[:error], 'Invalid email/password combination'

    skip "need some UI indication that they're logged in"
    # Assert that the user is not logged in. Maybe look for the absence of a logout link.
    assert_select "a[href=?]", logout_path, count: 0
  end

  test "should log out" do
    log_in_as(@larry_sellers, "password")
    delete logout_url
    assert_redirected_to root_url
    follow_redirect!

    skip "need some UI indication that they're logged in"
    # Check for some indication that user is logged out (maybe a flash message or some content change)
    assert_select "a[href=?]", login_path
  end

  test "should transfer seat reservations from a guest to the logged in user" do
    show = shows(:radiohead)
    show.build_seats
    show.save!

    get login_path # Just get a random endpoint so it will create the guest user
    guest = User::Guest.last

    seat = show.seats.where(reserved_by: nil, reserved_until: nil).first
    seat.reserve_for(guest)

    log_in_as(@larry_sellers, "password")

    seat.reload
    assert_equal @larry_sellers, seat.reserved_by

    perform_enqueued_jobs

    refute User.exists?(id: guest.id)
  end
end
