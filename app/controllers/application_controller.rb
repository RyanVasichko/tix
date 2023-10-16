class ApplicationController < ActionController::Base
  before_action :set_current_user

  default_form_builder DoseyDoeTicketsFormBuilder::FormBuilder

  private

  def set_current_user
    Current.user =
      if session[:user_id]
        User.find_by(id: session[:user_id]) || create_guest
      else
        create_guest
      end

    @current_user_id = Current.user.id
  end

  def create_guest
    guest = User::Guest.create!
    session[:user_id] = guest.id
    guest
  end
end
