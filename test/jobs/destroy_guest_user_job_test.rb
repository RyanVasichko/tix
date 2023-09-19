require "test_helper"

class DestroyGuestUserJobTest < ActiveJob::TestCase
  test "should remove the guest user" do
    guest = User::Guest.create
    DestroyGuestUserJob.perform_now(guest.id)
    refute User.find_by(id: guest.id)
  end

  test "should not remove customers" do
    new_user = User::Customer.create!(
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    assert_no_difference("User.count") { DestroyGuestUserJob.perform_now(new_user.id) }
  end

  test "should not remove admins" do
    new_user = User::Admin.create!(
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    assert_no_difference("User.count") { DestroyGuestUserJob.perform_now(new_user.id) }
  end

  test "guest user should be removed after a week" do
    guest = User::Guest.create
    travel_to 1.week.from_now do
      perform_enqueued_jobs
      refute User.find_by(id: guest.id)
    end
  end
end
