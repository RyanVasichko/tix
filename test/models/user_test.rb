require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should enqueue DestroyGuestUserJob after creating a guest user" do
    guest = FactoryBot.create(:guest)
    assert_enqueued_with(job: DestroyGuestUserJob, args: [guest.id])
  end

  test "should not enqueue DestroyGuestUserJob for customers" do
    assert_no_enqueued_jobs(only: DestroyGuestUserJob) do
      FactoryBot.create(:customer)
    end
  end

  test "should not enqueue DestroyGuestUserJob for admins" do
    assert_no_enqueued_jobs(only: DestroyGuestUserJob) do
      FactoryBot.create(:admin)
    end
  end
end
