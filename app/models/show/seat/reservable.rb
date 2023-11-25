module Show::Seat::Reservable
  extend ActiveSupport::Concern

  included do
    belongs_to :shopping_cart,
               optional: true,
               class_name: "User::ShoppingCart",
               foreign_key: :user_shopping_cart_id,
               inverse_of: :seats
    has_one :reserved_by, through: :shopping_cart, source: :user

    after_update_commit :queue_expiration_job, if: -> { saved_change_to_reserved_until? || saved_change_to_user_shopping_cart_id? }

    after_touch -> { broadcast_replace_later_to [show, "seating_chart"], partial: "shows/seats/seat" }
    after_update_commit -> { broadcast_replace_later_to [show, "seating_chart"], partial: "shows/seats/seat" }
    after_update_commit :broadcast_shopping_cart_later
  end

  def transfer_reservation!(from:, to:)
    return unless reserved_by == from

    with_lock { update!(reservation_params_for_user(to)) }
  end

  def reserve_for(user)
    with_lock { update(reservation_params_for_user(user)) } if reservable_by?(user)
  end

  def reserve_for!(user)
    with_lock { update!(reservation_params_for_user(user)) } if reservable_by?(user)
  end

  def cancel_reservation!
    with_lock { update!(shopping_cart: nil, reserved_until: nil) }
  end

  private

  def reservable_by?(user)
    (shopping_cart.nil? || shopping_cart == user.shopping_cart || reserved_until.past?) && !sold?
  end

  def reservation_params_for_user(user)
    { shopping_cart: user.shopping_cart, reserved_until: Time.current + user.ticket_reservation_time }
  end

  def queue_expiration_job
    return unless shopping_cart || reserved_until

    ExpireSeatReservationJob.set(wait_until: self.reserved_until).perform_later(self.id)
  end

  def broadcast_shopping_cart_later
    broadcast_shopping_cart_replacement_later(User::ShoppingCart.find(user_shopping_cart_id_previously_was)) if user_shopping_cart_id_previously_was.present?
    broadcast_shopping_cart_replacement_later(shopping_cart) if shopping_cart.present?
  end

  def broadcast_shopping_cart_replacement_later(shopping_cart)
    broadcast_replace_later_to shopping_cart,
                               target: "shopping_cart",
                               partial: "shopping_cart/shopping_cart",
                               locals: {
                                 shopping_cart: shopping_cart
                               }

    broadcast_replace_later_to shopping_cart,
                               target: "shopping_cart_count",
                               partial: "shopping_cart/count",
                               locals: {
                                 shopping_cart: shopping_cart
                               }
  end
end
