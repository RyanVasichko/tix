class Admin::AdminsController < Admin::BaseUsersController
  include SearchParams

  def destroy
    @user.deactivate!

    redirect_back_or_to admin_admins_path, flash: { notice: "Admin was successfully deactivated." }
  end

  private

  def user_klass
    Users::Admin
  end

  def user_params
    params.fetch(:users_admin, {}).permit(base_permitted_parameters.concat(%i[user_role_id active]))
  end

  def index_path
    admin_admins_path
  end
end
