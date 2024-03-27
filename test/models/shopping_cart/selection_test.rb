require "test_helper"

class ShoppingCart::SelectionTest < ActiveSupport::TestCase
  test "destroying a selection does not destroy its selectables that are not destroyed with selection" do
    selection = FactoryBot.create(:shopping_cart_merch_selection)
    assert_not selection.selectable.destroyed_with_selection?

    selection.destroy!
    assert_not selection.selectable.destroyed?
  end

  test "destroying a selection destroys its selectables that are destroyed with selection" do
    selection = FactoryBot.create(:shopping_cart_general_admission_ticket_selection)
    assert selection.selectable.destroyed_with_selection?

    selection.destroy!
    assert selection.selectable.destroyed?
  end

  test "should be destroyed when expired" do
    selection = FactoryBot.create(:shopping_cart_reserved_seating_ticket_selection, expires_at: 5.minutes.from_now)

    travel_to 4.minutes.from_now do
      perform_enqueued_jobs
    end
    assert ShoppingCart::Selection.exists?(id: selection.id)

    travel_to 5.minutes.from_now do
      perform_enqueued_jobs
    end
    assert_not ShoppingCart::Selection.exists?(id: selection.id)
  end
end
