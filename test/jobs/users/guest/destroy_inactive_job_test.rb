require "test_helper"

class Users::Guest::DestroyInactiveJobTest < ActiveJob::TestCase
  test "should destroy inactive guests" do
    guests = FactoryBot.create_list(:guest, 3)
    FactoryBot.create(:customer)
    FactoryBot.create(:admin)

    active_guest = guests.first

    travel_to 1.day.from_now + 1.second do
      active_guest.update(last_active_at: Time.current)

      assert_difference -> { Users::Guest.count } => -2, -> { User.count } => -2 do
        Users::Guest::DestroyInactiveJob.perform_now
      end
    end

    assert Users::Guest.exists?(id: active_guest.id)
  end
end
