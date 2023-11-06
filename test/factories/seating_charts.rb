FactoryBot.define do
  factory :seating_chart do
    name { Faker::Lorem.unique.word }
    active { true }
    association :venue

    transient do
      sections_count { 2 }
      section_seats_count { 5 }
      venue_layout_blob do
        ActiveStorage::Blob.create_and_upload!(
          io: File.open(Rails.root.join("test", "fixtures", "files", "seating_chart.bmp")),
          filename: "seating_chart.bmp",
          content_type: "image/bmp"
        )
      end
    end

    after(:build) do |seating_chart, evaluator|
      seating_chart.venue_layout.attach(evaluator.venue_layout_blob)

      if seating_chart.sections.empty?
        seating_chart.sections << FactoryBot.build_list(
          :seating_chart_section,
          evaluator.sections_count,
          seating_chart: seating_chart,
          seats_count: evaluator.section_seats_count
        )
      end
    end
  end
end