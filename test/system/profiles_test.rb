require "application_system_test_case"

class ProfilesTest < ApplicationSystemTestCase
  setup do
    @user = FactoryBot.create(:customer)
    sign_in @user
  end

  test "editing my profile" do
    visit edit_user_url

    fill_in "First name", with: "UpdatedFirst"
    fill_in "Last name", with: "UpdatedLast"
    fill_in "Phone", with: "555-555-5555"
    click_on "Update"

    assert_text "Your profile has been successfully updated."
    assert_equal "UpdatedFirst", @user.reload.first_name
    assert_equal "UpdatedLast", @user.last_name
    assert_equal "555-555-5555", @user.phone
  end

  test "changing my password" do
    visit edit_user_url
    fill_in "Current password", with: "Radiohead"
    fill_in "New password", with: "NewPassword"
    fill_in "Password confirmation", with: "NewPassword"
    click_on "Change my password"

    assert_text "Your profile has been successfully updated."
    assert @user.reload.authenticate("NewPassword")
  end

  test "deleting my account" do
    visit edit_user_url

    assert_difference -> { Users::Customer.count }, -1 do
      click_on "Delete my account"
      accept_confirm
      assert_text "Your account has been successfully deleted."
    end
    assert_nil User.find_by_id(@user.id)
  end
end
