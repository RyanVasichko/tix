class User::Session < ApplicationRecord
  ACTIVITY_REFRESH_RATE = 1.hour

  belongs_to :user, class_name: "User", inverse_of: :sessions

  has_secure_token

  before_create { self.last_active_at ||= Time.now }

  def resume
    return unless Time.current > ACTIVITY_REFRESH_RATE.ago

    update!(last_active_at: Time.current)
  end
end
