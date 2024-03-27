class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :set_current_user, :refresh_last_active_at

  default_form_builder StandardFormBuilder::FormBuilder

  private

  HOURS_TO_UPDATE_LAST_ACTIVE_AT_AFTER = 1

  def set_current_user
    Current.user =
      if session[:user_id]
        User.find_by(id: session[:user_id]) || create_guest
      else
        create_guest
      end
  end

  def create_guest
    Users::Guest.create!.tap { |guest| session[:user_id] = guest.id }
  end

  def refresh_last_active_at
    return if Current.user.last_active_at.present? && Current.user.last_active_at > HOURS_TO_UPDATE_LAST_ACTIVE_AT_AFTER.hours.ago
    Current.user.update(last_active_at: Time.current)
  end
end
