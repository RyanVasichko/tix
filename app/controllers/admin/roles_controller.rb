class Admin::RolesController < Admin::AdminController
  def index
    @pagy, @roles = pagy(User::Role.all, items: 25)
  end

  def bulk_update
    ActiveRecord::Base.transaction do
      params[:roles].each do |id, role_params|
        if id == "new"
          User::Role.create!(role_params.permit(:name, :hold_seats, :release_seats, :manage_customers, :manage_admins))
        else
          role = User::Role.find(id)
          role.update!(role_params.permit(:name, :hold_seats, :release_seats, :manage_customers, :manage_admins))
        end
      end
    end

    redirect_back_or_to admin_roles_path, flash: { notice: "Roles were successfully updated." }
  end

  def destroy
    @role = User::Role.find(params[:id])
    if @role.destroy
      flash[:notice] = "Role was successfully destroyed."
    else
      flash[:error] = @role.errors.full_messages.join(", ")
    end

    redirect_back_or_to admin_roles_path
  end

  private

  def bulk_update_params
  end
end
