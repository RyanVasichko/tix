require "system/admin/base_user_test_case"

class Admin::CustomersTest < Admin::BaseUserTestCase
  setup do
    @users = FactoryBot.create_list(:customer, 5)
    @admin = FactoryBot.create(:admin)

    log_in_as(@admin)
  end

  test "visiting the index" do
    run_visit_the_index_test
  end

  test "creating a customer" do
    run_create_user_test
  end

  test "updating a customer" do
    run_update_user_test
  end

  test "destroying a customer" do
    customer = @users.first
    orders = FactoryBot.create_list(:customer_order, 5, orderer: customer)

    expected_differences = {
      "User::Customer.count" => -1,
      "Order::GuestOrderer.count" => 1
    }
    assert_difference expected_differences do
      visit admin_customers_path
      within "##{dom_id(customer, :admin)}" do
        find("##{dom_id(customer, :admin)}_dropdown").click
        click_on "Delete"
      end

      assert_text "Customer was successfully destroyed."
    end

    assert_nil User::Customer.find_by(id: customer.id)

    orders.each do |order|
      assert order.reload.orderer.is_a?(Order::GuestOrderer)
      assert_equal order.orderer.first_name, customer.first_name
      assert_equal order.orderer.last_name, customer.last_name
      assert_equal order.orderer.email, customer.email
      assert_equal order.orderer.phone, customer.phone
      refute_equal order.orderer.shopper_uuid, customer.shopper_uuid
    end
  end

  private

  def user_type
    "Customer"
  end

  def index_path
    admin_customers_path
  end
end
