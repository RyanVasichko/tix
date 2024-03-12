require "application_system_test_case"

class Merch::ShippingChargesTest < ApplicationSystemTestCase
  setup do
    @shipping_charge = FactoryBot.create(:merch_shipping_charge)

    visit admin_merch_index_url
    click_on "Shipping Charges"
    assert_text @shipping_charge.weight
  end

  test "visiting the index" do
    assert_text @shipping_charge.price
    assert_text @shipping_charge.weight
  end

  test "should create shipping charge" do
    find("#new_merch_shipping_charge").click
    fill_in "Price", with: 42
    fill_in "Weight", with: 69
    click_on "Create Shipping charge"

    assert_text "Merch shipping charge was successfully created"
  end

  test "should update Shipping charge" do
    sleep 0.1
    find("##{dom_id(@shipping_charge, :admin)}_dropdown").click
    click_on "Edit"
    assert_text "Edit Shipping Charge"

    fill_in "Price", with: 18
    fill_in "Weight", with: 23
    click_on "Update Shipping charge"

    assert_text "Merch shipping charge was successfully updated"
    assert_equal 18, @shipping_charge.reload.price
    assert_equal 23, @shipping_charge.weight
  end

  test "should destroy Shipping charge" do
    sleep 0.1
    find("##{dom_id(@shipping_charge, :admin)}_dropdown").click
    click_on "Delete"

    assert_text "Merch shipping charge was successfully destroyed."
  end
end
