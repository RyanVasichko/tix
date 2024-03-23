FactoryBot.define do
  factory :general_admission_ticket, class: Tickets::GeneralAdmission do
    association :show_section, factory: :general_admission_show_section
  end

  factory :reserved_seating_ticket, class: Tickets::ReservedSeating do
    after :build do |ticket|
      ticket.show_section ||= FactoryBot.build(:reserved_seating_show_section, tickets: [ticket])
      ticket.seat ||= FactoryBot.build(:show_seat, ticket: ticket)
    end
  end
end
