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

  test "creating a admin" do
    run_create_user_test
  end

  test "updating a admin" do
    run_update_user_test
  end

  private

  def user_type
    "Customer"
  end

  def index_path
    admin_customers_path
  end
end
