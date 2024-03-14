module Show::Seat::Holdable
  extend ActiveSupport::Concern

  included do
    belongs_to :held_by_admin, class_name: "Users::Admin", inverse_of: :held_seats, optional: true
    delegate :name, to: :held_by_admin, prefix: true, allow_nil: true

    scope :held, -> { where.not(held_by_admin: nil) }
    scope :not_held, -> { where(held_by_admin: nil) }

    scope :seat_holds_keyword_search, ->(keyword) {
      joins(:held_by_admin).where(<<~SQL, keyword: "%#{keyword}%")
        CONCAT(users.first_name, ' ', users.last_name) LIKE :keyword
        OR show_seats.seat_number LIKE :keyword
        OR show_seats.table_number LIKE :keyword
      SQL
    }

    scope :order_by_held_by_admin_name, ->(direction) {
      joins(:held_by_admin).order("users.first_name #{direction}, users.last_name #{direction}")
    }
  end

  def held?
    held_by_admin.present?
  end

  def hold_for_admin!(admin)
    with_lock { update!(hold_params_for_admin(admin)) } if holdable_by?(admin)
  end

  def hold_for_admin(admin)
    with_lock { update(hold_params_for_admin(admin)) } if holdable_by?(admin)
  end

  def release_hold!(user)
    with_lock { update!(cancel_hold_params) } if user.admin? && held?
  end

  def release_hold(user)
    with_lock { update(cancel_hold_params) } if user.admin? && held?
  end

  private

  def hold_params_for_admin(admin)
    { held_by_admin: admin, reserved_until: nil, shopping_cart: nil }
  end

  def cancel_hold_params
    { held_by_admin: nil }
  end

  def holdable_by?(admin)
    admin.admin? && reserved_by == admin && !sold? && !held?
  end
end
