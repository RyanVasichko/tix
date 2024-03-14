require "system/admin/base_user_test_case"

class Admin::AdminsTest < Admin::BaseUserTestCase
  setup do
    @users = FactoryBot.create_list(:admin, 5)
    @admin = FactoryBot.create(:admin)
    @roles = FactoryBot.create_list(:user_role, 5)

    log_in_as(@admin)
  end

  test "visiting the index" do
    run_visit_the_index_test
  end

  test "creating a admin" do
    run_create_user_test do
      select @roles.third.name, from: "Role"
    end

    created_user = Users::Admin.last
    assert_equal @roles.third.id, created_user.user_role_id
  end

  test "updating a admin" do
    run_update_user_test do
      select @roles.third.name, from: "Role"
    end

    assert_equal @roles.third.id, @user.reload.user_role_id
  end

  test "deactivating an admin" do
    visit admin_admins_path

    user = @users.first
    find("##{dom_id(user, :admin)}_dropdown").click
    click_on "Deactivate"

    assert_text "Admin was successfully deactivated."
    assert user.reload.deactivated?
    refute_text user.name
    check "Include deactivated?"
    assert_text user.name
  end

  private

  def user_type
    "Admin"
  end

  def index_path
    admin_admins_path
  end
end
