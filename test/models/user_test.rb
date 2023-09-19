require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should enqueue DestroyGuestUserJob after creating a guest user" do
    guest = User::Guest.create!
    assert_enqueued_with(job: DestroyGuestUserJob, args: [guest.id])
  end

  test "should not enqueue DestroyGuestUserJob for customers" do
    assert_no_enqueued_jobs(only: DestroyGuestUserJob) do
      User::Customer.create!(
        first_name: "John",
        last_name: "Doe",
        email: "john.doe@example.com",
        password: "password123",
        password_confirmation: "password123"
      )
    end
  end

  test "should not enqueue DestroyGuestUserJob for admins" do
    assert_no_enqueued_jobs(only: DestroyGuestUserJob) do
      User::Admin.create!(
        first_name: "John",
        last_name: "Doe",
        email: "john.doe@example.com",
        password: "password123",
        password_confirmation: "password123"
      )
    end
  end
end
