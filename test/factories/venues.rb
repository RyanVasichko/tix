FactoryBot.define do
  factory :venue do
    name { "#{Faker::Company.name} Arena" }
    active { true }

    transient do
      ticket_types_count { 1 }
    end

    after(:build) do |venue, evaluator|
      if venue.ticket_types.empty?
        venue.ticket_types = build_list(:ticket_type, evaluator.ticket_types_count, venue: venue)
      end
    end
  end
end
