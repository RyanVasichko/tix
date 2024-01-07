require 'pagy/extras/array'

class Admin::RolesController < Admin::AdminController
  def index
    @pagy, @roles = pagy(User::Role.order(:id), items: 100_000)
  end

  def update
    @role = User::Role.find(params[:id])
    if @role.update(role_params)
      redirect_back_or_to admin_roles_path, flash: { notice: "Role was successfully updated." }
    else
      flash.now[:error] = @role.errors[:base].join(", ") if @role.errors[:base].any?
      @roles = User::Role.order(:id).to_a
      @roles[@roles.index{ |role| role.id == @role.id }] = @role
      @pagy, @roles = pagy_array(@roles, items: 100_000)
      render :index, status: :unprocessable_entity
    end
  end

  def new
    @pagy, @roles = pagy_array(User::Role.order(:id).to_a.prepend(User::Role.new), items: 100_000)
    render :index
  end

  def create
    @role = User::Role.new(role_params)
    if @role.save
      flash[:notice] = "Role was successfully created."
      redirect_back_or_to admin_roles_path
    else
      flash.now[:error] = @role.errors[:base].join(", ") if @role.errors[:base].any?
      @pagy, @roles = pagy_array(User::Role.order(:id).to_a.prepend(@role), items: 100_000)
      render :index, status: :unprocessable_entity
    end
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

  def role_params
    params.fetch(:user_role, {}).permit(:name, :hold_seats, :release_seats, :manage_customers, :manage_admins)
  end
end
