class Admin::CustomersController < Admin::BaseUsersController
  include Searchable

  def destroy
    @customer = User::Customer.find(params[:id])
    @customer.destroy!

    redirect_back_or_to admin_customers_path, flash: { notice: "Customer was successfully destroyed." }
  end

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
