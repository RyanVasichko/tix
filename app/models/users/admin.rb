class Users::Admin < User
  include Authenticateable, Orderer

  has_many :held_seats, class_name: "Tickets::ReservedSeating", inverse_of: :held_by, foreign_key: "held_by_id"
  belongs_to :role, class_name: "User::Role", foreign_key: :user_role_id

  def can?(perform_action)
    role.send(perform_action)
  end

  def admin?
    true
  end
end
