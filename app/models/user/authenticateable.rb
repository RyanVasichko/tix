module User::Authenticateable
  extend ActiveSupport::Concern

  included do
    has_secure_password validations: true

    validates :first_name, :last_name, :email, presence: true
    validates :email, uniqueness: true, presence: true
  end
end