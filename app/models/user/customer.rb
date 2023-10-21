class User::Customer < User
  include Authenticateable, Orderer

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  def order_form_type
    Order::CustomerOrderForm
  end

  def customer?
    true
  end
end
