require "application_system_test_case"

class User::ShoppingCartMerchSystemTest < ApplicationSystemTestCase
  setup { @merch = merch(:tank_top) }

  test "should add merch to shopping cart" do
    log_in_as(users(:larry_sellers), "password")

    visit merch_index_url
    find("##{dom_id(@merch)}").click
    select 3, from: "Quantity"
    find("label[for=user_shopping_cart_merch_option_m]").click
    click_on "Add to Shopping Cart"
    assert_text "Tank Top was added to your shopping cart."

    assert users(:larry_sellers).shopping_cart_merch.where(merch: @merch, quantity: 3, option: "M").exists?
  end
end
