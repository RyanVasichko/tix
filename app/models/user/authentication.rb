module User::Authentication
  extend ActiveSupport::Concern

  included do
    validates :password, length: { minimum: 8 }, if: :password_digest_changed?

    validates :first_name, :last_name, presence: true

    validates :email, presence: true, uniqueness: true
    normalizes :email, with: ->(email) { email.strip.downcase }
  end

  def password_reset_token
    signed_id(purpose: "password_reset", expires_in: 6.hours)
  end
end
