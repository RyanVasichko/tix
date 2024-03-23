FactoryBot.define do
  trait(:past) { show_date { Faker::Date.backward(days: 730) } }

  trait :show do
    artist { nil }
    venue { nil }

    show_date { Faker::Date.forward(days: 120) }
    doors_open_at { Faker::Time.between(from: DateTime.now.change(hour: 17), to: DateTime.now.change(hour: 19)) }
    dinner_starts_at { doors_open_at + rand(0...30).minutes }
    show_starts_at { dinner_starts_at + rand(0...15).minutes }
    dinner_ends_at { dinner_starts_at + 1.hour }
    front_end_on_sale_at { show_date - rand(15...60).days }
    front_end_off_sale_at { show_date + 1.day }
    back_end_on_sale_at { front_end_on_sale_at - rand(15...30).days }
    back_end_off_sale_at { show_date + 1.day }
    additional_text { Faker::Lorem.paragraph }
    deposit_amount { Faker::Commerce.price(range: 0..25.0) }

    transient do
      sections_count { 2 }
      with_existing_artist { false }
      with_existing_venue { false }
    end

    after :build do |show, evaluator|
      show.artist ||= evaluator.with_existing_artist ? Artist.all.sample : FactoryBot.build(:artist)
      show.venue ||= evaluator.with_existing_venue ? Venue.all.sample : FactoryBot.build(:venue)
    end
  end

  factory :reserved_seating_show, traits: [:show], class: Shows::ReservedSeating do
    seating_chart_name { Faker::Lorem.word }
    type { Shows::ReservedSeating.to_s }

    transient do
      section_tickets_count { 5 }
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
      show.upsales << FactoryBot.build(:show_upsale, show: show) if Faker::Boolean.boolean(true_ratio: 0.1)

      if show.sections.empty?
        show.sections = FactoryBot.build_list(
          :reserved_seating_show_section,
          evaluator.sections_count,
          show: show,
          tickets_count: evaluator.section_tickets_count)
      end

      show.venue_layout.attach(evaluator.venue_layout_blob)
    end
  end

  factory :general_admission_show, traits: [:show], class: Shows::GeneralAdmission do
    type { "Shows::GeneralAdmission" }

    after(:build) do |show, evaluator|
      # Build an upsale for 10% of shows
      show.upsales << FactoryBot.build(:show_upsale, show: show) if Faker::Boolean.boolean(true_ratio: 0.1)

      if show.sections.empty?
        show.sections = FactoryBot.build_list(
          :general_admission_show_section,
          evaluator.sections_count,
          show: show)
      end
    end
  end
end
