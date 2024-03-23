require "test_helper"

class Merch::ShoppingCartSelectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @merch = FactoryBot.create(:merch)
    @customer = FactoryBot.create(:customer)
    sign_in @customer
  end

  test "new return a form for a merch selection" do
    get new_merch_shopping_cart_selection_url(@merch)
    assert_response :success
    assert_match @merch.name, response.body
  end

  test "new should not return a form for deactivated merch" do
    @merch.update! active: false
    assert_raises(ActiveRecord::RecordNotFound) do
      get new_merch_shopping_cart_selection_url(@merch)
    end
  end

  test "post should add merch to the shopping cart if merch has not already been selected for the same option" do
    assert_difference -> { ShoppingCart::Selection.count }, 1 do
      post merch_shopping_cart_selections_url(@merch),
           params: {
             shopping_cart_selection: { quantity: 2, options: { "size" => "large" } }
           }
      assert_redirected_to merch_index_url
    end

    assert @customer.shopping_cart_selections.where(selectable: @merch, quantity: 2, options: { "size" => "large" }).exists?
  end

  test "post should not add deactivated merch to the shopping cart" do
    @merch.update! active: false

    assert_raises(ActiveRecord::RecordNotFound) do
      post merch_shopping_cart_selections_url(@merch),
           params: {
             shopping_cart_selection: { quantity: 2, options: { "size" => "large" } }
           }
    end
  end

  test "post should increment the quantity if merch has already been selected for the same option" do
    selection = FactoryBot.create :shopping_cart_merch_selection,
                                  selectable: @merch,
                                  options: { "size" => "large" },
                                  shopping_cart: @customer.shopping_cart, quantity: 2

    assert_difference -> { @customer.shopping_cart_selections.count }, 0 do
      post merch_shopping_cart_selections_url(@merch),
           params: {
             shopping_cart_selection: { quantity: 3, options: { "size" => "large" } }
           }
      assert_redirected_to merch_index_url
    end

    assert_equal 5, selection.reload.quantity
  end
end
