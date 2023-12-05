require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  test "placing an order as an existing Customer" do
    customer = FactoryBot.create(:customer, shopping_cart_merch_count: 2, reserved_seats_count: 2, general_admission_tickets_count: 2)

    assert_difference "customer.orders.reload.count" do
      log_in_as(customer, "password")

      find("#shopping_cart_toggle").click
      click_on "Checkout"

      fill_in_address_information
      fill_in_credit_card_information

      expected_differences = {
        "Order::Merch.count" => 2,
        "Order::Ticket.count" => 4,
        "Order.count" => 1,
        "User::ShoppingCart::Ticket.count" => -2
      }
      assert_difference expected_differences do
        click_on "Place Order"
        assert_text "Your order was successfully placed", wait: 30
      end
    end

    created_order = customer.orders.last

    assert_equal "1214 Test St.", created_order.shipping_address.address_1
    assert_equal "APT 7203", created_order.shipping_address.address_2
    assert_equal "Houston", created_order.shipping_address.city
    assert_equal "TX", created_order.shipping_address.state
    assert_equal "77019", created_order.shipping_address.zip_code

    assert_equal 2, created_order.merch.count
    assert_equal 4, created_order.tickets.count
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

    visit reserved_seating_show_url(reserved_seating_show)
    seat = reserved_seating_show.seats.where(shopping_cart: nil).first
    find("##{dom_id(seat)}").click

    visit shows_url
    within "##{dom_id(general_admission_show)}" do
      click_on "Order Tickets"
    end

    select 2, from: general_admission_show.sections.first.name
    click_on "Add to shopping cart"

    all(".toast_dismiss").each(&:click)

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

    expected_differences = {
      "Order::Merch.count" => 2,
      "Order::Ticket.count" => 2,
      "Order.count" => 1,
      "User::ShoppingCart::Ticket.count" => -1,
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

  test "removing general admission tickets from the new order screen" do
    set_up_removals_test
    general_admission_ticket = @customer.shopping_cart.tickets.first
    find("#destroy_#{dom_id(general_admission_ticket)}").click

    count = 0
    sleep 0.05 while !@customer.shopping_cart.reload.tickets.empty? && ++count < 5
    assert @customer.shopping_cart.reload.tickets.empty?
  end

  test "removing reserved seating tickets from the new order screen" do
    set_up_removals_test
    reserved_seat = @customer.shopping_cart.seats.first
    find("#destroy_#{dom_id(reserved_seat)}_reservation").click

    count = 0
    sleep 0.05 while !@customer.shopping_cart.reload.seats.empty? && ++count < 5
    assert @customer.shopping_cart.reload.seats.empty?
  end

  test "removing merch from the new order screen" do
    set_up_removals_test
    merch = @customer.shopping_cart.merch.first
    find("#destroy_#{dom_id(merch)}").click

    count = 0
    sleep 0.05 while !@customer.shopping_cart.reload.merch.empty? && ++count < 5
    assert @customer.shopping_cart.reload.merch.empty?
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

  def set_up_removals_test
    @customer = FactoryBot.create(:customer,
                                  shopping_cart_merch_count: 1,
                                  reserved_seats_count: 1,
                                  general_admission_tickets_count: 1)

    log_in_as(@customer, "password")

    find("#shopping_cart_toggle").click
    click_on "Checkout"
  end
end
