require "application_system_test_case"

class ShoppingCart::MerchSystemTest < ApplicationSystemTestCase
  test "should add merch to shopping cart" do
    merch = FactoryBot.create(:merch)
    customer = FactoryBot.create(:customer)
    option = merch.options.sample
    sign_in customer

    visit merch_index_url
    find("##{dom_id(merch)}").click
    select 3, from: "Quantity"
    find("label[for=shopping_cart_merch_option_#{option}]").click
    click_on "Add to Shopping Cart"
    assert_text "#{merch.name} was added to your shopping cart."

    assert customer.shopping_cart_merch.where(merch: merch, quantity: 3, option: option).exists?
  end
end
