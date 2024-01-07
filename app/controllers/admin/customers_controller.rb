class Admin::CustomersController < Admin::BaseUsersController
  include Searchable

  private

  def user_type
    User::Customer
  end

  def user_params
    params.fetch(:user_customer, {}).permit(:first_name, :last_name, :email, :password, :password_confirmation, :phone)
  end

  def users_index_path
    admin_customers_path
  end

  def user_type_name
    "Customer"
  end
end
