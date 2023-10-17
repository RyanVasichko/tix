FactoryBot.define do
  factory :seating_chart do
    name { Faker::Lorem.word }
    active { true }

    transient do
      sections_count { 4 }
      section_seats_count { 20 }
    end

    after(:build) do |seating_chart, evaluator|
      seating_chart.venue_layout.attach(
        io: File.open(Rails.root.join('test', 'fixtures', 'files', 'seating_chart.bmp')),
        filename: 'seating_chart.bmp',
        content_type: 'image/bmp'
      )

      if seating_chart.sections.empty?
        seating_chart.sections << FactoryBot.build_list(
          :seating_chart_section,
          evaluator.sections_count,
          :skip_seating_chart,
          seating_chart: seating_chart,
          seats_count: evaluator.section_seats_count
        )
      end
    end
  end
end