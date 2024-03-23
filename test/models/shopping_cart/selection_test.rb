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
end
