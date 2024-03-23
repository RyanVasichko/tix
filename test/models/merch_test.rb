require "test_helper"

class MerchTest < ActiveSupport::TestCase
  test "should destroy shopping cart merch selections when deactivated" do
    merch = FactoryBot.create(:merch)
    merch_selection = FactoryBot.create(:shopping_cart_merch_selection, selectable: merch)

    merch.deactivate!
    assert_raises ActiveRecord::RecordNotFound do
      merch_selection.reload
    end
  end
end
