FactoryBot.define do
  trait :show_section do
    ticket_price { Faker::Commerce.price(range: 25..100.0) }
    name { "#{Faker::Lorem.unique.sentence(word_count: 4)}" }
  end

  factory :reserved_seating_show_section, traits: [:show_section], class: Show::Sections::ReservedSeating do
    transient do
      tickets_count { 5 }
      show_deposit_amount { 0 }
    end

    type { Show::Sections::ReservedSeating.to_s }
    payment_method { Show::Sections::ReservedSeating.payment_methods.keys.sample }
    convenience_fee_type { Show::Sections::ReservedSeating.convenience_fee_types.keys.sample }
    convenience_fee { Faker::Commerce.price(range: 0.1..10.0) }
    venue_commission { Faker::Commerce.price(range: 0..5.0) }

    transient do
      ticket_type { nil }
    end

    after(:build) do |show_section, evaluator|
      show_section.show ||= FactoryBot.build(:reserved_seating_show, sections: [show_section], deposit_amount: evaluator.show_deposit_amount)

      if show_section.tickets.empty?
        show_section.tickets = FactoryBot.build_list :reserved_seating_ticket,
                                                     evaluator.tickets_count,
                                                     show_section: show_section
      end

      if evaluator.ticket_type
        show_section.payment_method = evaluator.ticket_type.payment_method
        show_section.convenience_fee_type = evaluator.ticket_type.convenience_fee_type
        show_section.convenience_fee = evaluator.ticket_type.convenience_fee
        show_section.venue_commission = evaluator.ticket_type.venue_commission
      end
    end
  end

  factory :general_admission_show_section, traits: [:show_section], class: Show::Sections::GeneralAdmission.to_s do
    association :show, factory: :general_admission_show
    type { Show::Sections::GeneralAdmission.to_s }
    convenience_fee { Faker::Commerce.price(range: 0..10.0) }
  end
end
