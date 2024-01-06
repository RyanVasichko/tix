class User::Admin < User
  include Authenticateable, Orderer

  has_many :held_seats, class_name: "Show::Seat", inverse_of: :held_by_admin, foreign_key: "held_by_admin_id"
  belongs_to :role, class_name: "User::Role", foreign_key: :user_role_id

  def can?(perform_action)
    role.send(perform_action)
  end

  def order_form_type
    Order::AdminOrderForm
  end

  def admin?
    true
  end
end
