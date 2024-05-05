require "system/admin/base_user_test_case"

class Admin::AdminsTest < Admin::BaseUserTestCase
  setup do
    @users = FactoryBot.create_list(:admin, 5)
    @admin = FactoryBot.create(:admin)
    @roles = FactoryBot.create_list(:user_role, 5)

    sign_in @admin
  end

  test "visiting the index" do
    run_visit_the_index_test
  end

  test "creating a admin" do
    assert_difference -> { Users::Admin.count }, 1 do
      run_create_user_test do
        select @roles.third.name, from: "Role"
      end
    end

    created_user = Users::Admin.last
    assert_equal @roles.third.id, created_user.user_role_id

    assert_enqueued_email_with UserMailer, :password_reset_email, args: created_user
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
    within "tr", text: user.name do
      click_on "Deactivate"
    end

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
