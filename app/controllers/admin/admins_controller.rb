class Admin::AdminsController < Admin::BaseUsersController
  include Searchable

  private

  def user_type
    User::Admin
  end

  def user_params
    params.fetch(:user_admin, {}).permit(:first_name, :last_name, :user_role_id, :email, :password, :password_confirmation, :phone)
  end

  def users_index_path
    admin_admins_path
  end

  def user_type_name
    "Admin"
  end
end
