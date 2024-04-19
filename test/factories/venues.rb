FactoryBot.define do
  factory :venue do
    name { "#{Faker::Company.unique.name} Arena" }
    active { true }
    association :address

    transient do
      ticket_types_count { 1 }
    end

    after(:build) do |venue, evaluator|
      venue.ticket_types = build_list(:ticket_type, evaluator.ticket_types_count, venue: venue) if venue.ticket_types.empty?
    end
  end
end
