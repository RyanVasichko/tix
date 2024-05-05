module SessionTestHelper
  def sign_in(user)
    post new_user_session_url, params: { session: { email: user.email, password: "Radiohead" } }
    assert_response :redirect
    follow_redirect!
    assert_includes response.body, "You have been signed in successfully."
  end

  def sign_out(user)
    delete destroy_user_session_url
    assert_response :redirect
    follow_redirect!
    assert_includes response.body, "You have been signed out successfully."
  end
end
