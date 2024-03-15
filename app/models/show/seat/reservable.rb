module Show::Seat::Reservable
  extend ActiveSupport::Concern

  included do
    belongs_to :shopping_cart,
               optional: true,
               class_name: "ShoppingCart",
               foreign_key: :shopping_cart_id,
               inverse_of: :seats,
               touch: true
    before_save -> { ShoppingCart.find_by(id: shopping_cart_id_previously_was)&.touch },
                if: -> { shopping_cart_id_previously_was.present? && shopping_cart_id_previously_changed? }

    has_one :reserved_by, through: :shopping_cart, source: :user

    scope :reserved, -> { where(reserved_until: Time.current...) }

    after_update_commit :queue_expiration_job, if: -> { saved_change_to_reserved_until? || saved_change_to_shopping_cart_id? }
    after_update_commit -> { broadcast_replace_later_to [show, "seating_chart"], partial: "reserved_seating_shows/seats/seat" }
  end

  def reserved?
    reserved_until&.future?
  end

  def transfer_reservation_to!(recipient)
    with_lock { update!(reservation_params_for_user(recipient)) }
  end

  def reserve_for(user)
    with_lock { update(reservation_params_for_user(user)) } if reservable_by?(user)
  end

  def reserve_for!(user)
    with_lock { update!(reservation_params_for_user(user)) } if reservable_by?(user)
  end

  def cancel_reservation_for!(user)
    with_lock { update!(cancel_reservation_params) } if reserved_by == user
  end

  def cancel_reservation_for(user)
    with_lock { update(cancel_reservation_params) } if reserved_by == user
  end

  private

  def reservable_by?(user)
    (shopping_cart.nil? || shopping_cart == user.shopping_cart || reserved_until.past?) && !sold? && !held?
  end

  def reservation_params_for_user(user)
    { shopping_cart: user.shopping_cart, reserved_until: Time.current + user.ticket_reservation_time }
  end

  def cancel_reservation_params
    { shopping_cart: nil, reserved_until: nil }
  end

  def queue_expiration_job
    return unless shopping_cart || reserved_until

    ExpireSeatReservationJob.set(wait_until: self.reserved_until).perform_later(self.id)
  end
end
