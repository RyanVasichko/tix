FactoryBot.define do
  trait :show_section do
    ticket_price { Faker::Commerce.price(range: 25..100.0) }
    name { Faker::Lorem.word }

    transient do
      seats_count { 5 }
    end
  end

  factory :reserved_seating_show_section, traits: [:show_section], class: Show::ReservedSeatingSection.to_s do
    association :show, factory: :reserved_seating_show
    type { Show::ReservedSeatingSection.to_s }
    payment_method { Show::ReservedSeatingSection.payment_methods.keys.sample }
    convenience_fee_type { Show::ReservedSeatingSection.convenience_fee_types.keys.sample }
    convenience_fee { convenience_fee_type == :flat_rate ? Faker::Commerce.price(range: 0..10.0) : Faker::Commerce.price(range: 0.1..10.0) }
    venue_commission { Faker::Commerce.price(range: 0..5.0) }

    transient do
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

  factory :general_admission_show_section, traits: [:show_section], class: Show::GeneralAdmissionSection.to_s do
    association :show, factory: :general_admission_show
    type { Show::GeneralAdmissionSection.to_s }
    convenience_fee { Faker::Commerce.price(range: 0..10.0) }
  end
end
