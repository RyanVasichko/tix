require "test_helper"

class Admin::Merch::SortOrderControllerTest < ActionDispatch::IntegrationTest
  test "sorts merch" do
    merch1 = FactoryBot.create(:merch, order: 1)
    merch2 = FactoryBot.create(:merch, order: 2)

    payload = {
      merch: [
        { id: merch1.id, order: 2 },
        { id: merch2.id, order: 1 }
      ]
    }

    put admin_merch_sort_order_path, params: payload

    assert_response :success
    assert_equal 2, merch1.reload.order
    assert_equal 1, merch2.reload.order
  end
end
