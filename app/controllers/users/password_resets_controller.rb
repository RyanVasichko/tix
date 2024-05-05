class Users::PasswordResetsController < ApplicationController
  before_action :require_no_authentication
  before_action :set_user, only: [:edit, :update]
  before_action :validate_token, only: [:edit, :update]

  def new
  end

  def create
    @user = User.active.customer_or_admin.find_by_email(params.dig(:user, :email))
    UserMailer.password_reset_email(@user).deliver_later

    redirect_to root_path,
                flash: { notice: "If you have an account an email has been sent with instructions for resetting your password." }
  end

  def edit
  end

  def update
    if @user.update(password_reset_params)
      start_new_session_for(@user)
      redirect_to root_path, flash: { notice: "Your password has been successfully reset." }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_reset_params
    params.permit(:password, :password_confirmation)
  end

  def set_user
    @user = User.active.find_signed(params[:reset_password_token], purpose: "password_reset")
  end

  def validate_token
    redirect_to new_user_password_reset_path, flash: { warn: "Your reset token has expired. Please try again." } unless @user
  end
end
