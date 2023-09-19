module Show::Seat::Reservable
  extend ActiveSupport::Concern

  included do
    belongs_to :reserved_by,
               class_name: "User",
               inverse_of: :reserved_seats,
               foreign_key: "reserved_by_id",
               optional: true

    after_update_commit :queue_expiration_job,
                        if: -> { saved_change_to_reserved_until? || saved_change_to_reserved_by_id? }

    after_update_commit -> { broadcast_replace_to [show, "seating_chart"], partial: "shows/seats/seat" },
                        if: -> { saved_change_to_reserved_by_id? }

    after_touch -> { broadcast_replace_to [show, "seating_chart"], partial: "shows/seats/seat" }

    after_update_commit :broadcast_shopping_cart_count,
                        if: -> { saved_change_to_reserved_by_id? && reserved_by_id_previously_was }

    attr_accessor :skip_broadcasting_shopping_cart
    after_update_commit :broadcast_shopping_cart,
                        if: -> {
                          saved_change_to_reserved_by_id? && reserved_by_id_previously_was &&
                            !skip_broadcasting_shopping_cart
                        }
  end

  def transfer_reservation(from:, to:)
    return unless reserved_by == from

    with_lock { update(reserved_by: to, reserved_until: Time.current + to.ticket_reservation_time) }
  end

  def reserve_for(user)
    return unless reserved_by.nil? || reserved_by == user || reserved_until.past?

    with_lock { update(reserved_by: user, reserved_until: Time.current + user.ticket_reservation_time) }
  end

  def cancel_reservation!
    with_lock { update!(reserved_by: nil, reserved_until: nil) }
  end

  private

  def queue_expiration_job
    return unless reserved_by_id || reserved_until

    ExpireSeatReservationJob.set(wait_until: self.reserved_until).perform_later(self.id)
  end

  def broadcast_shopping_cart_count
    user = User.includes(reserved_seats: [{ section: { show: :artist } }]).find(reserved_by_id_previously_was)
    broadcast_replace_later_to [user, "shopping_cart"],
                               target: "shopping_cart_count",
                               partial: "shopping_cart/count",
                               locals: {
                                 user: user
                               }
  end

  def broadcast_shopping_cart
    user = User.includes(reserved_seats: [{ section: { show: :artist } }]).find(reserved_by_id_previously_was)
    broadcast_replace_later_to [user, "shopping_cart"],
                               target: "shopping_cart",
                               partial: "shopping_cart/shopping_cart",
                               locals: {
                                 user: user
                               }
  end
end
