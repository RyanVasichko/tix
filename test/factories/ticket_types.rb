FactoryBot.define do
  factory :ticket_type do
    sequence(:name) { |n| "Ticket Type #{n}" }
    convenience_fee_type { TicketType.convenience_fee_types.map { |k, v| k }.sample }
    convenience_fee { convenience_fee_type == "percentage" ? Faker::Number.between(from: 1, to: 10) : Faker::Commerce.price(range: 1...10.0) }
    default_price { Faker::Commerce.price(range: 30...150.0) }
    venue_commission { Faker::Commerce.price(range: 1...3.0) }
    dinner_included { true }
    active { true }
    payment_method { TicketType.payment_methods.map { |k, v| k }.sample }

    association :venue
  end
end
