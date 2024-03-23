module Show::Seat::Holdable
  extend ActiveSupport::Concern

  included do
    has_one :held_by, class_name: "Users::Admin", through: :ticket, source: :held_by
    delegate :name, :shopper_uuid, to: :held_by, prefix: true, allow_nil: true
    delegate :held?, :hold_for!, :release_hold!, to: :ticket

    scope :held, -> { joins(:held_by) }
    scope :not_held, -> { where.missing(:held_by) }

    scope :seat_holds_keyword_search, ->(keyword) {
      joins(:held_by).where(<<~SQL, keyword: "%#{keyword}%")
        CONCAT(users.first_name, ' ', users.last_name) LIKE :keyword
        OR show_seats.seat_number LIKE :keyword
        OR show_seats.table_number LIKE :keyword
      SQL
    }

    scope :order_by_held_by_name, ->(direction) {
      joins(:held_by).order("users.first_name #{direction}, users.last_name #{direction}")
    }
  end
end
