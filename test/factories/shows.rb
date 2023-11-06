FactoryBot.define do
  factory :show do
    show_date { Faker::Date.forward(days: 60) }
    doors_open_at { Faker::Time.between(from: DateTime.now.change(hour: 17), to: DateTime.now.change(hour: 19)) }
    show_starts_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    dinner_starts_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    dinner_ends_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    front_end_on_sale_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    front_end_off_sale_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    back_end_on_sale_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    back_end_off_sale_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    additional_text { Faker::Lorem.paragraph }
    seating_chart_name { Faker::Lorem.word }

    association :artist
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

    after(:build) do |show, evaluator|
      # Build an upsale for 10% of shows
      show.upsales << FactoryBot.build(:show_upsale) if Faker::Boolean.boolean(true_ratio: 0.1)

      if show.sections.empty?
        show.sections = FactoryBot.build_list(
          :show_section,
          evaluator.sections_count,
          show: show,
          seats_count: evaluator.section_seats_count)
      end

      show.venue_layout.attach(evaluator.venue_layout_blob)
    end
  end
end