class User::Guest < User
  after_create_commit -> { DestroyGuestUserJob.set(wait: 1.week).perform_later(self.id) }

  def order_form_type
    Order::GuestOrderForm
  end

  def becomes_customer!(email, first_name, last_name, phone)
    password = SecureRandom.hex(32)
    puts "*" * 90
    puts "password: #{password}"
    puts "*" * 90

    becomes!(User::Customer).update!(
      email: email,
      first_name: first_name,
      last_name: last_name,
      phone: phone,
      password: password,
      password_confirmation: password
    )

    # TODO: Queue email to customer letting them know their account has been created
  end

  def transfer_shopping_cart_to(user)
    reserved_seats.each { |s| s.transfer_reservation(from: self, to: user) }
  end

  def destroy_later
    DestroyGuestUserJob.perform_later(self.id)
  end
end
