class Admin::BaseUsersController < Admin::AdminController
  include SearchParams

  before_action :set_user, only: %i[edit update destroy]

  sortable_by :name, :email, :phone
  self.default_sort_field = :name

  def index
    @users = user_klass.search(search_params)
    @users = @users.active if user_klass == User::Admin && !include_deactivated?
    @pagy, @users = pagy(@users)
  end

  def new
    @user = user_klass.new

    render "admin/users/new"
  end

  def create
    @user = user_klass.new(user_params)
    if @user.save
      redirect_to index_path, flash: { notice: "#{user_class_name} was successfully created." }
    else
      respond_to do |format|
        format.html { render "admin/users/edit", status: :unprocessable_entity }
        format.turbo_stream { render "admin/users/create", status: :unprocessable_entity }
      end
    end
  end

  def edit
    render "admin/users/edit"
  end

  def update
    if @user.update(user_params)
      redirect_back_or_to index_path, flash: { notice: "#{user_class_name} was successfully updated." }
    else
      respond_to do |format|
        format.html { render "admin/users/edit", status: :unprocessable_entity }
        format.turbo_stream { render "admin/users/update", status: :unprocessable_entity }
      end
    end
  end

  private

  def base_permitted_parameters
    %i[first_name last_name email password password_confirmation phone]
  end

  def set_user
    @user = user_klass.find(params[:id])
  end

  def user_klass
    raise NotImplementedError
  end

  def user_params
    raise NotImplementedError
  end

  def index_path
    raise NotImplementedError
  end

  def user_class_name
    user_klass.name.demodulize
  end
end
