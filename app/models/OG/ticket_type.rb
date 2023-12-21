module OG
  class TicketType < Record
    PAYMENT_METHODS = %w(deposit cover).freeze
    CONVENIENCE_FEES = %w(flat-rate percentage).freeze
  end
end
