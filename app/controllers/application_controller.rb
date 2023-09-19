class ApplicationController < ActionController::Base
  before_action :set_current_user

  private

  def set_current_user
    Current.user =
      if session[:user_id]
        User.find_by(id: session[:user_id])
      else
        guest = User::Guest.create!
        session[:user_id] = guest.id
        guest
      end

    @current_user_id = Current.user.id
  end
end
