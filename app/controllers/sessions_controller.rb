class SessionsController < ApplicationController
  def new
    redirect_to root_url, flash: { notice: "You are already logged in!" } unless Current.user.is_a? User::Guest
  end

  def create
    if user = User.active.authenticate_by(login_params)
      log_in user
      flash[:success] = "Welcome back, #{user.full_name}!"
      redirect_to root_url
    else
      flash.now[:error] = "Invalid email/password combination"
      respond_to do |format|
        format.html { render "new" }
        format.turbo_stream
      end
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def login_params
    params.fetch(:session, {}).permit(:email, :password)
  end

  def log_in(user)
    if Current.user.is_a? User::Guest
      Current.user.transfer_shopping_cart_to(user)
      Current.user.destroy_later
    end

    session[:user_id] = user.id
    Current.user = user
  end

  def logged_in?
    Current.user.present?
  end

  def log_out
    session.delete(:user_id)
    Current.user = nil
  end
end
