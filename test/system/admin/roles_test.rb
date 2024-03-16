require "application_system_test_case"

class Admin::RolesTest < ApplicationSystemTestCase
  setup do
    @admin = FactoryBot.create(:admin)
    @roles = FactoryBot.create_list(:user_role, 5)

    sign_in @admin
    visit admin_roles_path
  end

  test "visiting the index" do
    role = @roles.first

    within "##{dom_id(role, :admin)}" do
      assert_selector "input[type='text'][name='user_role[name]'][value='#{role.name}']"
    end
  end

  test "Updating a role" do
    role = @roles.first

    assert_not role.hold_seats
    assert_not role.release_seats
    assert_not role.manage_customers
    assert_not role.manage_admins

    within "##{dom_id(role, :admin)}" do
      fill_in "user_role[name]", with: "New Role"
      find("input[type='checkbox'][name='user_role[hold_seats]']").check
      find("input[type='checkbox'][name='user_role[release_seats]']").check
      find("input[type='checkbox'][name='user_role[manage_customers]']").check
      find("input[type='checkbox'][name='user_role[manage_admins]']").check
    end

    assert_text "Role was successfully updated"
    assert_equal "New Role", role.reload.name
    assert role.hold_seats
    assert role.release_seats
    assert role.manage_customers
    assert role.manage_admins
  end

  test "Creating a role" do
    click_on "Add role"

    within "#admin_user_role" do
      fill_in "user_role[name]", with: "Create New Role"
      find("input[type='text'][name='user_role[name]']").send_keys(:enter)
    end
    assert_text "Role was successfully created"
    dismiss_all_toast_messages
    refute_text "Role was successfully created"

    role = User::Role.find_by(name: "Create New Role")
    assert_not_nil role
    assert_not role.hold_seats
    assert_not role.release_seats
    assert_not role.manage_customers
    assert_not role.manage_admins

    check_field_and_dismiss_toast_messages_within_role role, "input[type='checkbox'][name='user_role[hold_seats]']"
    check_field_and_dismiss_toast_messages_within_role role, "input[type='checkbox'][name='user_role[release_seats]']"
    check_field_and_dismiss_toast_messages_within_role role, "input[type='checkbox'][name='user_role[manage_customers]']"
    check_field_and_dismiss_toast_messages_within_role role, "input[type='checkbox'][name='user_role[manage_admins]']"

    assert role.reload.hold_seats
    assert role.release_seats
    assert role.manage_customers
    assert role.manage_admins
  end

  private

  def check_field_and_dismiss_toast_messages_within_role(role, field_selector)
    within "##{dom_id(role, :admin)}" do
      find(field_selector).check
    end
    assert_text "Role was successfully updated"
    dismiss_all_toast_messages
    refute_text "Role was successfully updated"
  end
end
