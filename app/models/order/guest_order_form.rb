class Order::GuestOrderForm < Order::OrderForm
  before_create :set_guest_orderer
  attr_accessor :email, :first_name, :last_name, :phone

  validates_presence_of :email, :first_name, :last_name

  def collect_contact_information?
    true
  end

  def set_guest_orderer
    self.order.orderer = Order::GuestOrderer.new(
      email: email,
      first_name: first_name,
      last_name: last_name,
      phone: phone,
      shopper_uuid: Current.user.shopper_uuid)
  end
end
