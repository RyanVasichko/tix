class User::Admin < User
  include Authenticateable, Orderer

  has_many :held_seats, class_name: "Show::Seat", inverse_of: :held_by_admin, foreign_key: "held_by_admin_id"

  def order_form_type
    Order::AdminOrderForm
  end

  def admin?
    true
  end
end
