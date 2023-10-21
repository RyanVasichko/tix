FactoryBot.define do
  factory :show_section, class: 'Show::Section' do
    ticket_price { Faker::Commerce.price(range: 25..100.0) }
    name { Faker::Lorem.word }
    association :show

    transient do
      seats_count { 5 }
    end

    after(:build) do |show_section, evaluator|
      if show_section.seats.empty?
        show_section.seats = FactoryBot.build_list(
          :show_seat,
          evaluator.seats_count,
          section: show_section)
      end
    end
  end
end