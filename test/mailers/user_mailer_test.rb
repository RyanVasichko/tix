require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "should send password reset emails" do
    user = FactoryBot.create(:customer, email: "walter.sobchak@test.com")

    email = UserMailer.password_reset_email(user)

    assert_not_nil email
    assert_equal 'Reset your password', email.subject
    assert_equal ['walter.sobchak@test.com'], email.to
  end
end
