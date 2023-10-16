require "application_integration_test_case"

class ShoppingCart::MerchControllerTest < ApplicationIntegrationTestCase
  setup do
    @merch = merch(:tank_top)
    @shopping_cart_merch = user_shopping_cart_merch(:larry_sellers_bbq_sauce)
    log_in_as(users(:larry_sellers), "password")
  end

  test "should get new" do
    get new_shopping_cart_merch_url(merch_id: @merch.id)
    assert_response :success
  end

  test "should create shopping_cart_merch" do
    assert_difference("User::ShoppingCartMerch.count") do
      post shopping_cart_merch_index_url,
           params: {
             user_shopping_cart_merch: {
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
    patch shopping_cart_merch_url(@shopping_cart_merch), params: { user_shopping_cart_merch: { quantity: 3 } }

    assert_equal "Shopping cart was successfully updated.", flash[:success]
  end
end
