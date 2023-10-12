require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  test "placing an order as an existing Customer" do
    larry_sellers_order_count = users(:larry_sellers).orders.count
    log_in_as(users(:larry_sellers), "password")

    find("#shopping_cart_toggle").click
    click_on "Checkout"

    fill_in_address_information
    fill_in_credit_card_information

    click_on "Place Order"

    assert_text "Your order was successfully placed", wait: 30

    assert larry_sellers_order_count + 1, users(:larry_sellers).orders.count

    created_order = users(:larry_sellers).orders.last

    assert_equal "1214 Test St.", created_order.shipping_address.address
    assert_equal "APT 7203", created_order.shipping_address.address_2
    assert_equal "Houston", created_order.shipping_address.city
    assert_equal "TX", created_order.shipping_address.state
    assert_equal "77019", created_order.shipping_address.postal_code

    assert_equal 2, created_order.merch.count
    assert created_order
             .merch
             .where(merch: merch(:bbq_sauce), quantity: 3, unit_price: 4.99, total_price: 14.97)
             .exists?
    assert created_order
             .merch
             .where(merch: merch(:tank_top), quantity: 2, unit_price: 10.99, total_price: 21.98)
             .exists?
    assert_equal created_order.total_in_cents, 3695
  end

  test "placing an order as a guest" do
    bbq_sauce = merch(:bbq_sauce)
    tank_top = merch(:tank_top)
    radiohead = shows(:radiohead)

    radiohead.seating_chart.venue_layout.analyze

    visit merch_index_url

    find("##{dom_id(bbq_sauce)}").click
    select "3", from: "Quantity"
    click_on "Add to Shopping Cart"

    find("##{dom_id(tank_top)}").click
    select "2", from: "Quantity"
    click_on "Add to Shopping Cart"

    visit show_url(radiohead)
    seat = radiohead.seats.where(reserved_by: nil).first
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
      fill_in "Postal code", with: "77019"
    end
  end
end
