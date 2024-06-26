require "application_system_test_case"

class Admin::BaseUserTestCase < ApplicationSystemTestCase
  def run_visit_the_index_test
    visit index_path
    assert_text @users.first.name
  end

  def run_create_user_test
    visit index_path
    find("#new_users_#{user_type.downcase}").click

    fill_common_fields
    yield if block_given?

    assert_difference "Users::#{user_type}.count" do
      click_on "Create #{user_type}"
      assert_text "#{user_type} was successfully created."
    end

    assert_user_attributes(Users.const_get(user_type).last)
  end

  def run_update_user_test
    visit index_path

    @user = @users.first
    click_on @user.name

    fill_common_fields
    yield if block_given?

    assert_no_difference "Users::#{user_type}.count" do
      click_on "Update #{user_type}"
      assert_text "#{user_type} was successfully updated."
    end

    assert_user_attributes(@user.reload)
  end

  private

  def fill_common_fields
    fill_in "First name", with: "Test"
    fill_in "Last name", with: user_type
    fill_in "Email", with: "fake_email@test.com"
    fill_in "Phone", with: "555-555-5555"
  end

  def assert_user_attributes(user)
    assert_equal "Test", user.first_name
    assert_equal user_type, user.last_name
    assert_equal "fake_email@test.com", user.email
    assert_equal "555-555-5555", user.phone
  end

  def user_type
    raise NotImplementedError
  end

  def index_path
    raise NotImplementedError
  end
end
