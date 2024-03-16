require "test_helper"

class ShoppingCart::MerchControllerTest < ActionDispatch::IntegrationTest
  setup do
    @merch = FactoryBot.create(:merch)
    @shopping_cart_merch = FactoryBot.create(:shopping_cart_merch, merch: @merch)
    @user = FactoryBot.create(:customer)
    sign_in @user
  end

  test "should get new" do
    get new_shopping_cart_merch_url(merch_id: @merch.id)
    assert_response :success
  end

  test "should create shopping_cart_merch" do
    assert_difference("ShoppingCart::Merch.count") do
      post shopping_cart_merch_index_url,
           params: {
             shopping_cart_merch: {
               merch_id: @merch.id,
               quantity: 1,
               option: @merch.options.first
             }
           }
    end
    assert_redirected_to merch_index_url
    assert_equal "#{@merch.name} was added to your shopping cart.", flash[:success]
  end

  test "should update shopping_cart_merch" do
    patch shopping_cart_merch_url(@shopping_cart_merch), params: { shopping_cart_merch: { quantity: 3 } }

    assert_equal "Shopping cart was successfully updated.", flash[:success]
  end
end
