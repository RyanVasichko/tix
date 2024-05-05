class UsersController < ApplicationController
  before_action :require_no_authentication, only: [:new, :create]
  before_action :require_authentication, only: [:edit, :update, :destroy]
  before_action :set_user, only: [:edit, :update, :destroy]

  def new
    @user = Users::Customer.new
  end

  def create
    @user = Users::Customer.new(new_user_params)
    if @user.valid?
      @user.save
      start_new_session_for @user
      redirect_to root_path, flash: { notice: "Your account has been successfully created." }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(update_user_params)
      redirect_to edit_user_url, flash: { notice: "Your profile has been successfully updated." }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.admin?
      redirect_to edit_user_url, flash: { notice: "Admin accounts may not be deleted." }
      return
    end

    @user.destroy!
    redirect_to root_path, flash: { notice: "Your account has been successfully deleted." }
  end

  protected

  def set_user
    @user = Current.user
  end

  def new_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :password, :password_confirmation)
  end

  def update_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :password_challenge, :password, :password_confirmation)
  end
end
