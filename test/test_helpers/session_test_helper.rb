module SessionTestHelper
  def sign_in(user)
    post login_url, params: { session: { email: user.email, password: "Radiohead" } }
    assert_equal user.id, session[:user_id]
  end
end
