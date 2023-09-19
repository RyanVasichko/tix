module User::Reserver
  extend ActiveSupport::Concern

  included do
    has_many :reserved_seats,
             -> { where(reserved_until: Time.current..) },
             class_name: "Show::Seat",
             inverse_of: :reserved_by,
             foreign_key: "reserved_by_id"
  end

  def has_reserved_seats_for_show?(show)
    reserved_seats.joins(:show).where(shows: { id: show }).exists?
  end
end
