class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])

      log_in user
      redirect_to root_url
    else

      flash.now[:error] = 'Invalid email/password combination'
      respond_to do |format|
        format.html { render'new' }
        format.turbo_stream
      end
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def log_in(user)
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
