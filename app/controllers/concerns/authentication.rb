module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :set_current_user
  end

  private

  def require_no_authentication
    redirect_to root_path, flash: { alert: "You are already signed in." } if authenticated_user
  end

  def require_authentication
    redirect_to new_user_session_path, status: :unauthorized, flash: { error: "Please sign in first." } unless authenticated_user
  end

  def set_current_user
    Current.user = authenticated_user || guest_user
  end

  def authenticated_user
    session_from_cookies&.tap { |s| s&.resume }&.user
  end

  def session_from_cookies
    if token = cookies.signed[:session_token]
      if session = User::Session.includes(:user).find_by(token: token)
        return session
      else
        cookies.delete(:session_token)
        return nil
      end
    end
  end

  def guest_user
    guest_user_from_session || Users::Guest.create!.tap { |guest| session[:guest_user_id] = guest.id }
  end

  def guest_user_from_session
    if guest_user_id = session[:guest_user_id]
      Users::Guest.find_by_id(guest_user_id)
    end
  end

  def start_new_session_for(user)
    guest_user_from_session&.shopping_cart&.transfer_selections_to(user)
    session.delete(:guest_user_id)
    user.sessions.create!.tap do |session|
      cookies.signed.permanent[:session_token] = { value: session.token, httponly: true }
    end
    Current.user = user
  end
end
