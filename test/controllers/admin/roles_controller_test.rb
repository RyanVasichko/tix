require "test_helper"

class Admin::RolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in FactoryBot.create(:admin)
  end

  test "should get index" do
    get admin_roles_url
    assert_response :success
    assert_select "input[type='text'][value='superadmin']"
  end

  test "should get new" do
    get new_admin_role_url
    assert_response :success
  end

  test "update should update a role" do
    role = FactoryBot.create(:user_role)
    role_params = {
      name: "Updated Name",
      hold_seats: true,
      release_seats: true,
      manage_customers: true,
      manage_admins: true
    }

    put admin_role_url(role, params: { user_role: role_params })
    assert_response :redirect

    assert_equal "Updated Name", role.reload.name
    assert role.hold_seats
    assert role.release_seats
    assert role.manage_customers
    assert role.manage_admins
  end

  test "destroy should destroy a role" do
    role = FactoryBot.create(:user_role)
    assert_difference -> { User::Role.count }, -1 do
      delete admin_role_url(role)
    end
    assert_response :redirect
  end

  test "destroy should require at least one role with manage_admins permissions" do
    superadmin = User::Role.find_by_name!("superadmin")
    assert_difference -> { User::Role.count }, 0 do
      delete admin_role_url(superadmin)
    end
    assert_response :redirect

    new_role_with_manage_admins = FactoryBot.create(:user_role, manage_admins: true)
    assert_difference -> { User::Role.count }, -1 do
      delete admin_role_url(new_role_with_manage_admins)
    end
  end

  test "destroy should ensure the role is not being used by any admins" do
    new_role = FactoryBot.create(:user_role)
    FactoryBot.create(:admin, role: new_role)

    assert_difference -> { User::Role.count }, 0 do
      delete admin_role_url(new_role)
    end
    assert_response :redirect
  end
end
