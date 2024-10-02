require "test_helper"

class ShoppingCart::MerchSelectionsControllerTest < ActionDispatch::IntegrationTest
  test "update should update merch selections" do
    user = FactoryBot.create(:customer, shopping_cart_merch_count: 2)
    sign_in user

    merch_selection = user.shopping_cart_selections.merch.first

    patch shopping_carts_merch_selection_url(merch_selection), params: { shopping_cart_selection: { quantity: merch_selection.quantity + 2 } }
    assert_response :redirect

    assert_equal merch_selection.quantity + 2, merch_selection.reload.quantity
  end

  test "update should not update merch selections for another user" do
    user = FactoryBot.create(:customer)
    sign_in user

    merch_selection = FactoryBot.create(:shopping_cart_merch_selection)
    assert_not_equal user, merch_selection.user

    patch shopping_carts_merch_selection_url(merch_selection), params: { shopping_cart_selection: { quantity: merch_selection.quantity + 2 } }
    assert_response :not_found
  end

  test "destroy should destroy merch selections" do
    user = FactoryBot.create(:customer, shopping_cart_merch_count: 2)
    sign_in user

    merch_selection = user.shopping_cart_selections.merch.first

    delete shopping_carts_merch_selection_url(merch_selection)
    assert_response :redirect

    assert_not user.shopping_cart_selections.merch.exists?(merch_selection.id)
  end

  test "destroy should not destroy merch selections for another user" do
    user = FactoryBot.create(:customer)
    sign_in user

    merch_selection = FactoryBot.create(:shopping_cart_merch_selection)
    assert_not_equal user, merch_selection.user

    delete shopping_carts_merch_selection_url(merch_selection)
    assert_response :not_found
  end
end
