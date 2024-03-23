require "application_system_test_case"

class Merch::ShoppingCartSelectionsTest < ApplicationSystemTestCase
  setup do
    @merch = FactoryBot.create(:merch)
  end

  test "should create shopping cart selection" do
    merch = FactoryBot.create(:merch)
    customer = FactoryBot.create(:customer)
    option = merch.options.sample
    sign_in customer

    visit merch_index_url
    find("##{dom_id(merch)}").click
    select 3, from: "Quantity"
    find("label[for=shopping_cart_selection_options_value_#{option}]").click
    click_on "Add to Shopping Cart"
    assert_text "Your shopping was cart was successfully updated."

    expected_selection = customer.shopping_cart_selections.where \
      selectable: merch,
      quantity: 3,
      options: { name: merch.option_label, value: option }
    assert expected_selection.exists?
  end
end
