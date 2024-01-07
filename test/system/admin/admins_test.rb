require "system/admin/base_user_test_case"

class Admin::AdminsTest < Admin::BaseUserTestCase
  setup do
    @users = FactoryBot.create_list(:admin, 5)
    @admin = FactoryBot.create(:admin)

    log_in_as(@admin)
  end

  test "visiting the index" do
    run_visit_the_index_test
  end

  test "creating a admin" do
    run_create_user_test do
      # fill_in "User role id", with: "1"
    end

    #   Test role
  end

  test "updating a admin" do
    run_update_user_test do
      # fill_in "User role id", with: "2"
    end

    #   Test role
  end

  private

  def user_type
    "Admin"
  end

  def index_path
    admin_admins_path
  end
end
