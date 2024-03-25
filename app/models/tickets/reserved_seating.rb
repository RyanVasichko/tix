class Tickets::ReservedSeating < Ticket
  include Holdable, Selectable

  has_one :seat, class_name: "Show::Seat", inverse_of: :ticket, touch: true
  delegate :seat_number, :table_number, to: :seat

  after_commit -> { broadcast_replace_later_to [show, "seating_chart"], partial: "shows/reserved_seating/seats/seat", locals: { seat: seat } }

  def sold?
    purchase.present?
  end
end
