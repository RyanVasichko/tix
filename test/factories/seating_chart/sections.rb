FactoryBot.define do
  factory :seating_chart_section, class: 'SeatingChart::Section' do
    sequence(:name) { |n| "Section #{n}" }

    transient do
      seats_count { 5 }
    end

    after(:build) do |section, evaluator|
      section.seating_chart = FactoryBot.build(:seating_chart, sections: [section]) unless section.seating_chart.present?

      if section.seats.empty?
        section.seats << FactoryBot.build_list(
          :seating_chart_seat,
          evaluator.seats_count,
          section: section)
      end
    end
  end
end