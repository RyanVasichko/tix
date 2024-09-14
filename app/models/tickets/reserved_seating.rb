class Tickets::ReservedSeating < Ticket
  include Holdable, Selectable

  has_one :seat, class_name: "Show::Seat", inverse_of: :ticket, touch: true
  delegate :seat_number, :table_number, to: :seat

  after_commit :broadcast_seat_replacement_later

  def sold?
    purchase.present?
  end

  private

  def broadcast_seat_replacement_later
    broadcast_replace_to [show, "seating_chart"],
                         target: self.seat,
                         partial: "shows/reserved_seating/seats/seat",
                         locals: { seat: seat }
  end
end
