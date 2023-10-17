FactoryBot.define do
  factory :show_section, class: 'Show::Section' do
    ticket_price { Faker::Commerce.price(range: 25..100.0) }
    association :show
    association :seating_chart_section

    trait :skip_seating_chart_section do
      association :seating_chart_section, strategy: :null
    end

    trait :skip_show do
      association :show, strategy: :null
    end

    after(:build) do |show_section|
      # We don't need to build the seats because a section builds seats automatically before create
      # show_section.seating_chart_section.seats.each do |seat|
      #   FactoryBot.build(:show_seat,
      #                    :skip_section,
      #                    section: show_section,
      #                    x: seat.x,
      #                    y: seat.y,
      #                    seat_number: seat.seat_number.to_i,
      #                    table_number: seat.table_number.to_i
      #   )
      # end
    end
  end
end