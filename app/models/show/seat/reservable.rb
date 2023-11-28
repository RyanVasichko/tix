module Show::Seat::Reservable
  extend ActiveSupport::Concern

  included do
    belongs_to :shopping_cart,
               optional: true,
               class_name: "User::ShoppingCart",
               foreign_key: :user_shopping_cart_id,
               inverse_of: :seats,
               touch: true
    before_save -> { ShoppingCart.find_by(id: user_shopping_cart_id_previously_was)&.touch },
                if: -> { user_shopping_cart_id_previously_was.present? && user_shopping_cart_id_previously_changed? }

    has_one :reserved_by, through: :shopping_cart, source: :user

    after_update_commit :queue_expiration_job, if: -> { saved_change_to_reserved_until? || saved_change_to_user_shopping_cart_id? }
    after_update_commit -> { broadcast_replace_later_to [show, "seating_chart"], partial: "shows/seats/seat" }
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
end