FactoryBot.define do
  factory :show_section, class: 'Show::Section' do
    ticket_price { Faker::Commerce.price(range: 25..100.0) }
    name { Faker::Lorem.word }
    payment_method { Show::Section.payment_methods.keys.sample }
    convenience_fee_type { Show::Section.convenience_fee_types.keys.sample }
    convenience_fee { convenience_fee_type == :flat_rate ? Faker::Commerce.price(range: 0..10.0) : Faker::Commerce.price(range: 0.1..10.0) }
    venue_commission { Faker::Commerce.price(range: 0..5.0) }
    association :show

    transient do
      seats_count { 5 }
      ticket_type { nil }
    end

    after(:build) do |show_section, evaluator|
      if show_section.seats.empty?
        show_section.seats = FactoryBot.build_list(
          :show_seat,
          evaluator.seats_count,
          section: show_section)
      end

      if evaluator.ticket_type
        show_section.payment_method = evaluator.ticket_type.payment_method
        show_section.convenience_fee_type = evaluator.ticket_type.convenience_fee_type
        show_section.convenience_fee = evaluator.ticket_type.convenience_fee
        show_section.venue_commission = evaluator.ticket_type.venue_commission
      end
    end
  end
end