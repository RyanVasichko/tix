require "application_system_test_case"

class Merch::ShippingRatesTest < ApplicationSystemTestCase
  setup do
    @shipping_rate = FactoryBot.create(:merch_shipping_rate)

    visit admin_merch_index_url
    click_on "Shipping Rates"
    assert_text @shipping_rate.weight
  end

  test "visiting the index" do
    assert_text @shipping_rate.price
    assert_text @shipping_rate.weight
  end

  test "should create shipping rate" do
    find("#new_merch_shipping_rate").click
    fill_in "Price", with: 42
    fill_in "Weight", with: 69
    click_on "Create Shipping rate"

    assert_text "Merch shipping rate was successfully created"
  end

  test "should update Shipping rate" do
    within "tr", text: @shipping_rate.weight do
    click_on "Edit"
    end

    assert_text "Edit Shipping Rate"

    fill_in "Price", with: 18
    fill_in "Weight", with: 23
    click_on "Update Shipping rate"

    assert_text "Merch shipping rate was successfully updated"
    assert_equal 18, @shipping_rate.reload.price
    assert_equal 23, @shipping_rate.weight
  end

  test "should destroy Shipping rate" do
    within "tr", text: @shipping_rate.weight do
      click_on "Delete"
    end

    assert_text "Merch shipping rate was successfully destroyed."
  end
end
