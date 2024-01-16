class Order::GeneralAdmissionTicket < Order::Ticket
  attr_accessor :shopping_cart_ticket

  belongs_to :show_section, class_name: "Show::GeneralAdmissionSection", inverse_of: :order_tickets, foreign_key: "show_section_id"
  belongs_to :show, class_name: "Show::GeneralAdmissionShow", inverse_of: :tickets, foreign_key: "show_id"

  def deposit?
    false
  end

  def self.build_from_shopping_cart_tickets(tickets)
    tickets.map { |ticket| build_from_shopping_cart_ticket(ticket) }
  end

  def self.build_from_shopping_cart_ticket(ticket)
    build(show: ticket.show,
          show_section: ticket.show_section,
          quantity: ticket.quantity,
          shopping_cart_ticket: ticket)
      .tap(&:calculate_pricing)
  end

  def calculate_pricing
    self.ticket_price = show_section.ticket_price * quantity
    self.convenience_fees = show_section.ticket_convenience_fees * quantity
    self.venue_commission = show_section.venue_commission * quantity
    self.total_price = ticket_price + convenience_fees + venue_commission
  end
end
