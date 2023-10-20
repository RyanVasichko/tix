class User::Guest < User
  after_create_commit -> { DestroyGuestUserJob.set(wait: 1.week).perform_later(id) }

  def order_form_type
    Order::GuestOrderForm
  end

  def becomes_customer!(email, first_name, last_name, phone)
    password = SecureRandom.hex(32)

    becomes!(User::Customer).update!(
      email:,
      first_name:,
      last_name:,
      phone:,
      password:,
      password_confirmation: password
    )

    # TODO: Queue email to customer letting them know their account has been created
  end

  def transfer_shopping_cart_to(user)
    shopping_cart.transfer_from(self, to: user)
  end

  def destroy_later
    DestroyGuestUserJob.perform_later(id)
  end
end
