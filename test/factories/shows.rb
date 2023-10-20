FactoryBot.define do
  factory :show do
    show_date { Faker::Date.forward(days: 60) }
    doors_open_at { Faker::Time.between(from: DateTime.now - 2, to: DateTime.now) }
    show_starts_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    dinner_starts_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    dinner_ends_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    front_end_on_sale_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    front_end_off_sale_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    back_end_on_sale_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    back_end_off_sale_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    additional_text { Faker::Lorem.paragraph }

    association :artist
    association :seating_chart

    after(:build) do |show|
      # Build an upsale for 10% of shows
      show.upsales << FactoryBot.build(:show_upsale) if Faker::Boolean.boolean(true_ratio: 0.1)

      if show.seating_chart && !show.sections.any?
        show.seating_chart.sections.each do |seating_chart_section|
          show.sections << FactoryBot.build(
            :show_section,
            show: show,
            seating_chart_section: seating_chart_section)
        end
      end
    end
  end
end