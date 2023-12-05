require "test_helper"

class ApplicationIntegrationTestCase < ActionDispatch::IntegrationTest
  private

  def log_in_as(user, password = "password")
    post login_url, params: { session: { email: user.email, password: password } }
  end
end
