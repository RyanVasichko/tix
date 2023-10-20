require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  test "placing an order as an existing Customer" do
    customer = FactoryBot.create(:customer, shopping_cart_merch_count: 2, reserved_seats_count: 2)

    assert_difference "customer.orders.reload.count" do
      log_in_as(customer, "password")

      find("#shopping_cart_toggle").click
      click_on "Checkout"

      fill_in_address_information
      fill_in_credit_card_information

      click_on "Place Order"

      assert_text "Your order was successfully placed", wait: 30
    end


    created_order = customer.orders.last

    assert_equal "1214 Test St.", created_order.shipping_address.address_1
    assert_equal "APT 7203", created_order.shipping_address.address_2
    assert_equal "Houston", created_order.shipping_address.city
    assert_equal "TX", created_order.shipping_address.state
    assert_equal "77019", created_order.shipping_address.zip_code

    assert_equal 2, created_order.merch.count
    assert_equal 2, created_order.tickets.count
  end

  test "placing an order as a guest" do
    merch_1 = FactoryBot.create(:merch)
    merch_2 = FactoryBot.create(:merch)
    show = FactoryBot.create(:show)

    show.seating_chart.venue_layout.analyze

    visit merch_index_url

    find("##{dom_id(merch_1)}").click
    select "3", from: "Quantity"
    click_on "Add to Shopping Cart"

    find("##{dom_id(merch_2)}").click
    select "2", from: "Quantity"
    click_on "Add to Shopping Cart"

    visit show_url(show)
    seat = show.seats.where(shopping_cart: nil).first
    find("##{dom_id(seat)}").click

    sleep 0.25

    find("#shopping_cart_toggle").click

    click_on "Checkout"

    within "#order_contact_information" do
      fill_in "First name", with: "Donny"
      fill_in "Last name", with: "Kerabatsos"
      fill_in "Email", with: "dkerabatsos@testing.com"
      fill_in "Phone number", with: "713-555-5555"
    end

    fill_in_address_information
    within "#order_shipping_address" do
      fill_in "First name", with: "Donny"
      fill_in "Last name", with: "Kerabatsos"
    end
    fill_in_credit_card_information

    click_on "Place Order"
    assert_text "Your order was successfully placed", wait: 30
  end

  private

  def fill_in_credit_card_information
    frame = find('iframe[name^="__privateStripeFrame"]')
    within_frame(frame) do
      fill_in "Card number", with: "4242424242424242"
      fill_in "Expiration", with: "12/#{(Time.now.year + 1).to_s[-2..-1]}]}"
      fill_in "CVC", with: "123"
      fill_in "ZIP", with: "77019"
    end
  end

  def fill_in_address_information
    within "#order_shipping_address" do
      fill_in "Address", with: "1214 Test St."
      fill_in "Apartment, suite, etc.", with: "APT 7203"
      fill_in "City", with: "Houston"
      select "Texas", from: "State"
      fill_in "Zip code", with: "77019"
    end
  end
end
