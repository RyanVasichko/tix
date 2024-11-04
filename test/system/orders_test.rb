require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  setup do
    FactoryBot.create(:merch_shipping_rate, weight: 0.1)
  end

  test "placing an order as an existing Customer" do
    customer = FactoryBot.create(:customer, shopping_cart_merch_count: 2, reserved_seats_count: 2, general_admission_tickets_count: 2)

    assert_difference "customer.orders.reload.count" do
      sign_in customer
      visit root_path

      find("#shopping_cart_toggle").click
      click_on "Checkout"

      fill_in_address_information
      fill_in_credit_card_information

      expected_differences = {
        "customer.purchases.merch.count" => 2,
        "customer.purchases.tickets.count" => 4,
        "customer.orders.count" => 1,
        "customer.shopping_cart_selections.count" => -6
      }
      assert_difference expected_differences do
        click_on "Place Order"
        assert_text "Your order was successfully placed", wait: 30
      end
    end
  end

  test "placing an order as a guest" do
    merch_1 = FactoryBot.create(:merch)
    merch_2 = FactoryBot.create(:merch)
    reserved_seating_show = FactoryBot.create(:reserved_seating_show)
    general_admission_show = FactoryBot.create(:general_admission_show)

    reserved_seating_show.venue_layout.analyze

    visit merch_index_url

    find("##{dom_id(merch_1)}").click
    select "3", from: "Quantity"
    click_on "Add to Shopping Cart"

    find("##{dom_id(merch_2)}").click
    select "2", from: "Quantity"
    click_on "Add to Shopping Cart"

    visit shows_reserved_seating_url(reserved_seating_show)
    seat = reserved_seating_show.seats.available.first
    find("##{dom_id(seat)}").click

    visit shows_url
    within "##{dom_id(general_admission_show)}" do
      click_on "Order Tickets"
    end

    select 2, from: general_admission_show.sections.first.name
    click_on "Add to shopping cart"

    dismiss_all_toast_messages
    sleep 0.25
    find("#shopping_cart_toggle").click
    unless has_link? href: new_order_path, wait: 5
      find("#shopping_cart_toggle").click
    end

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

    expected_differences = {
      "Order::Purchase.merch.count" => 2,
      "Order::Purchase.tickets.count" => 2,
      "Order.count" => 1,
      "Order::GuestOrderer.count" => 1
    }
    assert_difference expected_differences do
      click_on "Place Order"
      assert_text "Your order was successfully placed", wait: 30
    end

    created_order = Order.last
    assert_equal "Donny", created_order.orderer.first_name
    assert_equal "Kerabatsos", created_order.orderer.last_name
    assert_equal "dkerabatsos@testing.com", created_order.orderer.email
    assert_equal "713-555-5555", created_order.orderer.phone

    assert_equal "1214 Test St.", created_order.shipping_address.address_1
    assert_equal "APT 7203", created_order.shipping_address.address_2
    assert_equal "Houston", created_order.shipping_address.city
    assert_equal "TX", created_order.shipping_address.state
    assert_equal "77019", created_order.shipping_address.zip_code
  end

  private

  def fill_in_credit_card_information
    frame = find('iframe[name^="__privateStripeFrame"]', wait: 10)
    within_frame(frame) do
      fill_in "Card number", with: "4242424242424242"
      fill_in "Expiration", with: "12/#{(Time.now.year + 1).to_s[-2..]}]}"
      fill_in "CVC", with: "123"
      fill_in "ZIP code", with: "77019"
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

  def set_up_removals_test
    @customer = FactoryBot.create(:customer,
                                  shopping_cart_merch_count: 1,
                                  reserved_seats_count: 1,
                                  general_admission_tickets_count: 1)

    sign_in @customer

    find("#shopping_cart_toggle").click
    click_on "Checkout"
  end
end
