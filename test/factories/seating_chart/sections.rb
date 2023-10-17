FactoryBot.define do
  factory :seating_chart_section, class: 'SeatingChart::Section' do
    name { Faker::Lorem.sentence }
    association :seating_chart

    trait :skip_seating_chart do
      association :seating_chart, strategy: :null
    end

    transient do
      seats_count { 20 }
    end

    after(:build) do |section, evaluator|
      if section.seats.empty?
        section.seats << FactoryBot.build_list(
          :seating_chart_seat,
          evaluator.seats_count,
          :skip_section,
          section: section)
      end
    end
  end
end