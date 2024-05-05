require "test_helper"

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:customer)
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should get new if the user is a guest" do
    get root_path # To create a guest account for the user
    get new_user_url
    assert_response :success
  end

  test "new should not allow already authenticated users" do
    sign_in @user
    get new_user_url
    assert_response :redirect
    follow_redirect!
    assert_includes response.body, "You are already signed in"
  end

  test "create should create a user" do
    assert_difference -> { Users::Customer.count } do
      post users_url, params: { user: new_user_params }
    end
    assert_response :redirect
  end

  test "create should not create a user without matching password confirmation" do
    assert_no_difference -> { Users::Customer.count } do
      post users_url, params: {
        user: new_user_params.tap { |p| p[:password] = "IRollOnShabbas" }
      }
    end
    assert_response :unprocessable_entity
  end

  test "create should not create a user when an account with that email already exists" do
    FactoryBot.create(:customer, email: "walter.sobchak@test.com")

    assert_no_difference -> { Users::Customer.count } do
      post users_url, params: { user: new_user_params }
    end
    assert_response :unprocessable_entity
  end

  test "create should not create a user when required fields are missing" do
    assert_no_difference -> { Users::Customer.count } do
      post users_url, params: { user: new_user_params.tap { |p| p.delete(:first_name) } }
    end
    assert_response :unprocessable_entity
  end

  test "update should update a user" do
    sign_in @user
    patch user_url, params: {
      user: {
        first_name: "Sonny",
        last_name: "Koufax",
        phone: "123-456-7890"
      }
    }
    assert_response :redirect

    assert_equal "Sonny", @user.reload.first_name
    assert_equal "Koufax", @user.last_name
    assert_equal "123-456-7890", @user.phone
  end

  test "update should not update if the user is not signed in" do
    get root_path
    patch user_url, params: {
      user: {
        first_name: "Sonny",
        last_name: "Koufax",
        phone: "123-456-7890"
      }
    }
    assert_response :unauthorized
  end

  test "update requires correct current password when changing a password" do
    sign_in @user
    patch user_url, params: {
      user: {
        password_challenge: "incorrect",
        password: "new_password",
        password_confirmation: "new_password"
      }
    }
    assert_response :unprocessable_entity
  end

  test "update requires password and password confirmation to match when changing a password" do
    sign_in @user
    patch user_url, params: {
      user: {
        password_challenge: "Radiohead",
        password: "new_password",
        password_confirmation: "different_password"
      }
    }
    assert_response :unprocessable_entity
  end

  test "update successfully updates password when changing a password" do
    sign_in @user
    patch user_url, params: {
      user: {
        password_challenge: "Radiohead",
        password: "new_password",
        password_confirmation: "new_password"
      }
    }
    assert_redirected_to edit_user_url
    assert @user.reload.authenticate("new_password")
  end

  test "destroy should not allow unauthenticated users" do
    delete user_url
    assert_response :unauthorized
  end

  test "destroy deletes a customer's account" do
    sign_in @user
    assert_difference -> { User.count }, -1 do
      delete user_url
    end
    assert_response :redirect
  end

  test "destroy does not delete an admin's account" do
    sign_in FactoryBot.create(:admin)
    assert_difference -> { User.count }, 0 do
      delete user_url
    end
    assert_response :redirect
    follow_redirect!
    assert_includes response.body, "Admin accounts may not be deleted."
  end

  private

  def new_user_params
    {
      email: "walter.sobchak@test.com",
      password: "IDontRollOnShabbas",
      password_confirmation: "IDontRollOnShabbas",
      first_name: "Walter",
      last_name: "Sobchak",
      phone: "123-456-7890"
    }
  end
end
