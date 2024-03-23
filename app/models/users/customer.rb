class Users::Customer < User
  include Authenticateable, Orderer

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  def customer?
    true
  end
end
