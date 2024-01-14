# test/system/base_user_test.rb
require "application_system_test_case"

class Admin::BaseUserTestCase < ApplicationSystemTestCase
  def run_visit_the_index_test
    visit index_path
    assert_text @users.first.full_name
  end

  def run_create_user_test
    visit index_path
    click_on "Add #{user_type.downcase}"

    fill_common_fields
    yield if block_given?

    assert_difference "User::#{user_type}.count" do
      click_on "Create #{user_type}"
      assert_text "#{user_type} was successfully created."
    end

    assert_user_attributes(User.const_get(user_type).last)
  end

  def run_update_user_test
    visit index_path

    @user = @users.first
    click_on @user.full_name

    fill_common_fields
    yield if block_given?

    assert_no_difference "User::#{user_type}.count" do
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
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
  end

  def assert_user_attributes(user)
    assert_equal "Test", user.first_name
    assert_equal user_type, user.last_name
    assert_equal "fake_email@test.com", user.email
    assert_equal "555-555-5555", user.phone
    assert user.authenticate("password")
  end

  def user_type
    raise NotImplementedError
  end

  def index_path
    raise NotImplementedError
  end
end
