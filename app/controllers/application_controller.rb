class ApplicationController < ActionController::Base
  before_action :set_current_user

  private

  def set_current_user
    Current.user = User.find_by(id: session[:user_id]) if session[:user_id]
    @current_user_id = Current.user.id if Current.user
  end
end
