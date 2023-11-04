class ApplicationController < ActionController::Base
  include Pagy::Backend

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
  end

  def create_guest
    User::Guest.create!.tap { |guest| session[:user_id] = guest.id }
  end
end
