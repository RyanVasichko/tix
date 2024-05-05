class Admin::AdminsController < Admin::BaseUsersController
  include SearchParams

  def destroy
    @user.deactivate!

    redirect_back_or_to admin_admins_path, flash: { notice: "Admin was successfully deactivated." }
  end

  def create
    @user = Users::Admin.new(user_params)
    if @user.save
      UserMailer.password_reset_email(@user).deliver_later
      redirect_to index_path, flash: { notice: "#{user_class_name} was successfully created." }
    else
      render "admin/users/new", status: :unprocessable_entity
    end
  end

  private

  def user_klass
    Users::Admin
  end

  def user_params
    params.fetch(:users_admin, {}).permit(base_permitted_parameters.concat(%i[user_role_id active])).tap do |permitted|
      permitted[:password] = SecureRandom.hex(32)
      permitted[:password_confirmation] = permitted[:password]
    end
  end

  def index_path
    admin_admins_path
  end
end
