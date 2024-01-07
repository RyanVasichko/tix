require "test_helper"

class DestroyGuestUserJobTest < ActiveJob::TestCase
  test "should remove the guest user" do
    guest = FactoryBot.create(:guest)
    DestroyGuestUserJob.perform_now(guest.id)
    refute User.find_by(id: guest.id)
  end

  test "should not remove customers" do
    new_user = FactoryBot.create(:customer)
    assert_no_difference("User.count") { DestroyGuestUserJob.perform_now(new_user.id) }
  end

  test "should not remove admins" do
    new_user = FactoryBot.create(:admin)
    assert_no_difference("User.count") { DestroyGuestUserJob.perform_now(new_user.id) }
  end

  test "guest user should be removed after a week" do
    guest = FactoryBot.create(:guest)
    travel_to 1.week.from_now do
      perform_enqueued_jobs
      refute User.find_by(id: guest.id)
    end
  end
end
