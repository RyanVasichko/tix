class Admin::CustomersController < Admin::BaseUsersController
  include SearchParams

  def destroy
    @customer = User::Customer.find(params[:id])
    @customer.destroy!

    redirect_back_or_to admin_customers_path, flash: { notice: "Customer was successfully destroyed." }
  end

  private

  def user_klass
    User::Customer
  end

  def user_params
    params.fetch(:user_customer, {}).permit(base_permitted_parameters)
  end

  def index_path
    admin_customers_path
  end
end
