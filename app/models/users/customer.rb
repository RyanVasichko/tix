class Users::Customer < User
  include Authentication, Orderer

  def customer?
    true
  end
end
