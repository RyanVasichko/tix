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

    trait :skip_seating_chart do
      association :seating_chart, strategy: :null
    end

    trait :skip_artist do
      association :artist, strategy: :null
    end

    after(:build) do |show|
      # Build an upsale for 10% of shows
      show.upsales << FactoryBot.build(:show_upsale) if Faker::Boolean.boolean(true_ratio: 0.1)

      if show.seating_chart
        show.seating_chart.sections.each do |section|
          FactoryBot.build(
            :show_section,
            :skip_seating_chart_section,
            :skip_show,
            show: show,
            seating_chart_section: section)
        end
      else
        show.seating_chart = FactoryBot.build(:seating_chart)
      end
    end
  end
end