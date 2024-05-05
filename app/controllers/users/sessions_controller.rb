class Users::SessionsController < ApplicationController
  before_action :require_no_authentication, only: [:new, :create]
  before_action :require_authentication, only: [:destroy]

  def new
  end

  def create
    if @user = User.active.authenticate_by(session_params)
      start_new_session_for(@user)
      redirect_to root_path, flash: { notice: "You have been signed in successfully." }
    else
      flash.now[:error] = "Invalid email or password."
      render :new, status: :unauthorized
    end
  end

  def destroy
    @session = session_from_cookies
    @session.destroy!
    redirect_to root_path, notice: "You have been signed out successfully."
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
