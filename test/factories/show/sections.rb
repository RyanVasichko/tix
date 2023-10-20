FactoryBot.define do
  factory :show_section, class: 'Show::Section' do
    ticket_price { Faker::Commerce.price(range: 25..100.0) }
    association :seating_chart_section

    after(:build) do |show_section|
      show_section.show = FactoryBot.build(:show, sections: [show_section]) unless show_section.show.present?

      show_section.build_seats
      show_section.seats.each { |seat| seat.show = show_section.show }
    end
  end
end