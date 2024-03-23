require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    WebMock.disable_net_connect!(allow_localhost: true)
    @user = FactoryBot.create(:customer, :with_password, stripe_customer_id: "cus_123")
    sign_in @user
  end

  teardown do
    WebMock.reset!
  end

  test "should get index" do
    @order = FactoryBot.create(:customer_order, orderer: @user)
    get orders_url
    assert_response :success
  end

  test "should get new" do
    mock_list_stripe_payment_methods
    FactoryBot.create(:shopping_cart_merch_selection, shopping_cart: @user.shopping_cart)
    get new_order_url
    assert_response :success
  end

  test "create should create an order with correct pricing for merch" do
    add_merch_to_shopping_cart
    mock_stripe_for_new_payment_creation amount: 2_500

    assert_difference("Order.count" => 1, "Order::Purchase.count" => 1, "Order::ShippingAddress.count" => 1) do
      post orders_url, params: { order: base_new_order_params.merge({ total_due_in_cents: 2_500, **shipping_address_attributes_params }) }
      assert_redirected_to order_url(Order.last)
    end

    assert @user.orders.exists?(total_price: 25, balance_paid: 25, shipping_charges: 5, total_fees: 0)
    assert @user.purchases.exists?(total_price: 20, quantity: 2, item_price: 10, total_fees: 0, balance_paid: 20, purchaseable_type: "Merch")
    assert @user.orders.joins(shipping_address: :address).exists? \
      shipping_address: {
        first_name: "Thom",
        last_name: "Yorke"
      },
      address: {
        address_1: "123 Radiohead Lane",
        address_2: nil,
        city: "Los Angeles",
        state: "California",
        zip_code: "90001"
      }
  end

  test "create should create an order with correct pricing for general admission tickets" do
    add_general_admission_ticket_to_shopping_cart
    mock_stripe_for_new_payment_creation(amount: 2_200)

    assert_difference("Order.count" => 1, "Order::Purchase.count" => 1) do
      post orders_url, params: { order: base_new_order_params.merge({ total_due_in_cents: 2_200 }) }
      assert_redirected_to order_url(Order.last)
    end

    assert @user.orders.exists?(total_price: 22, balance_paid: 22, shipping_charges: 0, total_fees: 2)
    assert @user.purchases.exists?(total_price: 22, balance_paid: 22, item_price: 10, total_fees: 2, quantity: 2, purchaseable_type: "Ticket")
  end

  test "create should create an order with correct pricing for reserved seating tickets with flat rate convenience fee types and cover payment methods" do
    execute_reserved_seating_ticket_test \
      payment_method: "cover",
      convenience_fee_type: "flat_rate",
      convenience_fee: 1,
      venue_commission: 2,
      expected_total_fees: 3.to_d,
      expected_balance_paid: 13.to_d,
      expected_item_price: 10.to_d,
      expected_total_price: 13.to_d
  end

  test "create should create an order with correct pricing for reserved seating tickets with flat rate convenience fee types and deposit payment methods" do
    execute_reserved_seating_ticket_test \
      payment_method: "deposit",
      convenience_fee_type: "flat_rate",
      show_deposit_amount: 5,
      convenience_fee: 1,
      venue_commission: 2,
      expected_total_fees: 3.to_d,
      expected_balance_paid: 8.to_d,
      expected_item_price: 10.to_d,
      expected_total_price: 13.to_d
  end

  test "create should create an order with correct pricing for reserved seating tickets with percentage convenience fee types and cover payment methods" do
    execute_reserved_seating_ticket_test \
      payment_method: "cover",
      convenience_fee_type: "percentage",
      convenience_fee: 10,
      venue_commission: 2,
      expected_total_fees: 3.to_d,
      expected_balance_paid: 13.to_d,
      expected_item_price: 10.to_d,
      expected_total_price: 13.to_d
  end

  test "create should create an order with correct pricing for reserved seating tickets with percentage convenience fee types and deposit payment methods" do
    execute_reserved_seating_ticket_test \
      payment_method: "deposit",
      convenience_fee_type: "percentage",
      show_deposit_amount: 5,
      convenience_fee: 10,
      venue_commission: 2,
      expected_total_fees: 3.to_d,
      expected_balance_paid: 8.to_d,
      expected_item_price: 10.to_d,
      expected_total_price: 13.to_d
  end

  test "create should create an order for merch, general admission tickets, and reserved seating tickets" do
    add_merch_to_shopping_cart
    add_general_admission_ticket_to_shopping_cart
    add_reserved_seating_ticket_to_shopping_cart(payment_method: "cover", convenience_fee_type: "flat_rate", convenience_fee: 1, venue_commission: 2)
    mock_stripe_for_new_payment_creation amount: 6_000
    order_params = base_new_order_params.merge({ total_due_in_cents: 6_000, **shipping_address_attributes_params })

    assert_difference("Order.count" => 1, "Order::Purchase.count" => 3) do
      post orders_url, params: { order: order_params }
      assert_redirected_to order_url(Order.last)
    end
  end

  test "create should create an order for merch, general admission tickets, and reserved seating tickets for a guest" do
    delete logout_url
    get root_url
    @user = Users::Guest.last

    add_merch_to_shopping_cart
    add_general_admission_ticket_to_shopping_cart
    add_reserved_seating_ticket_to_shopping_cart(payment_method: "cover", convenience_fee_type: "flat_rate", convenience_fee: 1, venue_commission: 2)

    mock_stripe_payment_method_retrieval
    mock_stripe_payment_intent_creation amount: 6_000, customer: nil
    order_params = base_new_order_params.merge(
      {
        total_due_in_cents: 6_000,
        guest_orderer_attributes: {
          email: "fake_email@test.com",
          first_name: "Walter",
          last_name: "Sobchak"
        },
        **shipping_address_attributes_params
      })

    assert_difference("Order.count" => 1, "Order::Purchase.count" => 3) do
      post orders_url, params: { order: order_params }
      assert_redirected_to order_url(Order.last)
    end

    assert Order::GuestOrderer.exists?(first_name: "Walter", last_name: "Sobchak", email: "fake_email@test.com", shopper_uuid: @user.shopper_uuid)
  end

  test "create should not allow a guest to place an order without contact information" do
    delete logout_url
    get root_url
    @user = Users::Guest.last

    add_merch_to_shopping_cart
    mock_stripe_payment_method_retrieval
    Stripe::PaymentIntent.expects(:create).never

    assert_no_difference("Order.count") do
      post orders_url, params: { order: base_new_order_params.merge({ total_due_in_cents: 2_500, **shipping_address_attributes_params }) }
      assert_response :unprocessable_entity
    end
  end

  test "create should save the user's credit card if they choose to" do
    add_merch_to_shopping_cart
    mock_stripe_customer_retrieval
    mock_stripe_payment_method_retrieval
    mock_stripe_payment_intent_creation amount: 2_500, setup_future_usage: :on_session

    assert_difference("Order.count" => 1) do
      post orders_url, params: { order: base_new_order_params.merge({ total_due_in_cents: 2_500, save_payment_method: "1", **shipping_address_attributes_params }) }
      assert_redirected_to order_url(Order.last)
    end
  end

  test "create should not save the user's credit card if they choose not to" do
    add_merch_to_shopping_cart
    mock_stripe_customer_retrieval
    mock_stripe_payment_method_retrieval
    mock_stripe_payment_intent_creation amount: 2_500

    assert_difference("Order.count" => 1) do
      post orders_url, params: { order: base_new_order_params.merge({ total_due_in_cents: 2_500, save_payment_method: "0", **shipping_address_attributes_params }) }
      assert_redirected_to order_url(Order.last)
    end
  end

  test "create should not allow other user's items to be purchased" do
    add_merch_to_shopping_cart
    mock_list_stripe_payment_methods

    other_user = FactoryBot.create(:customer)
    other_user.shopping_cart.selections.create(selectable: FactoryBot.create(:merch, price: 10, weight: 1))
    order_params = base_new_order_params.merge({ shopping_cart_selection_ids: other_user.shopping_cart.selections.map(&:id), total_due_in_cents: 2_500 })

    assert_no_difference "Order.count" do
      post orders_url, params: { order: order_params }
      assert_response :unprocessable_entity
    end
  end

  test "create should require a shipping address for merch purchases" do
    add_merch_to_shopping_cart
    mock_list_stripe_payment_methods

    assert_no_difference("Order.count") do
      post orders_url, params: { order: base_new_order_params.merge({ total_due_in_cents: 2_500 }) }
    end
  end

  test "create should not make any changes if payment fails" do
    add_merch_to_shopping_cart
    mock_stripe_customer_retrieval
    mock_stripe_payment_method_retrieval
    mock_list_stripe_payment_methods
    Stripe::PaymentIntent.expects(:create).returns(OpenStruct.new(id: "pi_123", status: "failed"))

    assert_no_difference([-> { Order.count }, -> { ShoppingCart::Selection.count }]) do
      post orders_url, params: { order: base_new_order_params.merge({ total_due_in_cents: 2_500, save_payment_method: "0", **shipping_address_attributes_params }) }
      assert_response :unprocessable_entity
    end
  end

  test "create should not make any changes if a Stripe error occurs" do
    add_merch_to_shopping_cart
    mock_stripe_customer_retrieval
    mock_stripe_payment_method_retrieval
    mock_list_stripe_payment_methods
    Stripe::PaymentIntent.expects(:create).raises(Stripe::StripeError)

    assert_no_difference([-> { Order.count }, -> { ShoppingCart::Selection.count }]) do
      post orders_url, params: { order: base_new_order_params.merge({ total_due_in_cents: 2_500, save_payment_method: "0", **shipping_address_attributes_params }) }
      assert_response :unprocessable_entity
    end
  end

  test "should show order" do
    @order = FactoryBot.create(:customer_order, orderer: @user)
    get order_url(@order)
    assert_response :success
  end

  private

  def execute_reserved_seating_ticket_test(**params)
    order_params = setup_reserved_seating_ticket_order_test(params)

    assert_difference("Order.count" => 1, "Order::Purchase.count" => 1) do
      post orders_url, params: { order: order_params }
      assert_redirected_to order_url(Order.last)
    end

    assert @user.orders.exists? \
      total_price: params[:expected_total_price],
      balance_paid: params[:expected_balance_paid],
      total_fees: params[:expected_total_fees],
      shipping_charges: 0

    assert @user.purchases.exists? \
      total_price: params[:expected_total_price],
      balance_paid: params[:expected_balance_paid],
      item_price: params[:expected_item_price],
      total_fees: params[:expected_total_fees],
      quantity: 1,
      purchaseable_type: "Ticket"
  end

  def setup_reserved_seating_ticket_order_test(params)
    add_reserved_seating_ticket_to_shopping_cart(params)
    mock_stripe_for_new_payment_creation amount: params[:expected_balance_paid].to_i * 100
    base_new_order_params.merge({ total_due_in_cents: params[:expected_balance_paid] * 100 })
  end

  def add_reserved_seating_ticket_to_shopping_cart(params)
    ticket = FactoryBot.create \
      :reserved_seating_ticket,
      show_section: FactoryBot.create(:reserved_seating_show_section,
                                      ticket_price: 10,
                                      show_deposit_amount: params[:show_deposit_amount] || 0,
                                      payment_method: params[:payment_method],
                                      convenience_fee_type: params[:convenience_fee_type],
                                      convenience_fee: params[:convenience_fee],
                                      venue_commission: params[:venue_commission])
    @user.shopping_cart.selections.create(selectable: ticket)
  end

  def add_general_admission_ticket_to_shopping_cart
    ticket = FactoryBot.create \
      :general_admission_ticket,
      show_section: FactoryBot.create(:general_admission_show_section,
                                      ticket_price: 10,
                                      payment_method: "cover",
                                      convenience_fee_type: "flat_rate",
                                      convenience_fee: 1)
    @user.shopping_cart.selections.create(selectable: ticket, quantity: 2)
  end

  def add_merch_to_shopping_cart
    merch = FactoryBot.create(:merch, price: 10, weight: 1)
    FactoryBot.create(:merch_shipping_rate, weight: 0.1, price: 5)
    @user.shopping_cart.selections.create!(selectable: merch, quantity: 2)
  end

  def mock_stripe_for_new_payment_creation(amount:)
    mock_stripe_customer_retrieval
    mock_stripe_payment_method_retrieval
    mock_stripe_payment_intent_creation amount: amount
  end

  def mock_stripe_customer_retrieval
    Stripe::Customer.stubs(:retrieve).returns(OpenStruct.new(id: "cus_123"))
  end

  def mock_list_stripe_payment_methods
    Stripe::Customer.stubs(:list_payment_methods).returns([])
  end

  def mock_stripe_payment_method_retrieval
    card_mock = OpenStruct.new(brand: "Visa", exp_month: 1, exp_year: Time.current.year + 1, last4: "4242")
    Stripe::PaymentMethod.stubs(:retrieve).returns(OpenStruct.new(card: card_mock))
  end

  def mock_stripe_payment_intent_creation(customizations = {})
    expectations = { payment_method: "pm_123", customer: "cus_123", setup_future_usage: nil }.merge(customizations)
    Stripe::PaymentIntent.expects(:create).with(has_entries(expectations)).returns(OpenStruct.new(id: "pi_123", status: "succeeded"))
  end

  def base_new_order_params
    {
      shopping_cart_selection_ids: @user.shopping_cart.selections.map(&:id),
      payment_method_id: "pm_123",
      save_payment_method: "0"
    }
  end

  def shipping_address_attributes_params
    {
      shipping_address_attributes: {
        first_name: "Thom",
        last_name: "Yorke",
        address_attributes: {
          address_1: "123 Radiohead Lane",
          city: "Los Angeles",
          state: "California",
          zip_code: "90001"
        }
      }
    }
  end
end
