class Order::GuestOrderForm < Order::OrderForm
  before_create :guest_becomes_customer
  attr_accessor :email, :first_name, :last_name, :phone

  validates_presence_of :email, :first_name, :last_name

  def collect_contact_information?
    true
  end

  def guest_becomes_customer
    user.becomes_customer!(email, first_name, last_name, phone)
  end
end
