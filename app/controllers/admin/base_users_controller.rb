class Admin::BaseUsersController < Admin::AdminController
  include Searchable

  before_action :set_user, only: %i[edit update]

  def index
    users = user_type.order(:first_name)
    users = users.keyword_search(search_keyword) if search_keyword.present?
    @pagy, @users = pagy(users)
  end

  def new
    @user = user_type.new
    render "admin/users/new"
  end

  def create
    @user = user_type.new(user_params)
    if @user.save
      redirect_to users_index_path, flash: { notice: "#{user_type_name} was successfully created." }
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
    @user.update(user_params)

    if @user.save
      redirect_to users_index_path, flash: { notice: "#{user_type_name} was successfully updated." }
    else
      respond_to do |format|
        format.html { render "admin/users/edit", status: :unprocessable_entity }
        format.turbo_stream { render "admin/users/update", status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = user_type.find(params[:id])
  end

  def user_type
    raise NotImplementedError
  end

  def user_params
    raise NotImplementedError
  end

  def users_index_path
    raise NotImplementedError
  end

  def user_type_name
    raise NotImplementedError
  end
end
