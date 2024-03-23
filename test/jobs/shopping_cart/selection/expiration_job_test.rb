require "test_helper"

class ShoppingCart::Selection::ExpirationJobTest < ActiveJob::TestCase
  test "should destroy the selection if it has expired" do
    selection = FactoryBot.create(:shopping_cart_reserved_seating_ticket_selection, expires_at: 1.day.ago)

    ShoppingCart::Selection::ExpirationJob.perform_now(selection)

    assert selection.destroyed?
  end

  test "should schedule the job to run again if the selection has not expired" do
    selection = FactoryBot.create(:shopping_cart_reserved_seating_ticket_selection, expires_at: 1.day.from_now)

    ShoppingCart::Selection::ExpirationJob.perform_now(selection)

    assert_enqueued_with(job: ShoppingCart::Selection::ExpirationJob, args: [selection], at: selection.expires_at)
  end
end
