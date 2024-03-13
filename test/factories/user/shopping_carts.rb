FactoryBot.define do
  factory :shopping_cart, class: "ShoppingCart" do
    transient do
      merch_count { 0 }
      reserved_seats_count { 0 }
      general_admission_tickets_count { 0 }
    end

    after(:build) do |shopping_cart, evaluator|
      shopping_cart.merch << FactoryBot.build_list(:shopping_cart_merch,
                                                   evaluator.merch_count,
                                                   quantity: 1)

      shopping_cart.seats << FactoryBot.build_list(:show_seat,
                                                   evaluator.reserved_seats_count,
                                                   shopping_cart: shopping_cart,
                                                   reserved_until: Time.zone.now + 15.minutes)

      shopping_cart.tickets << FactoryBot.build_list(:shopping_cart_ticket,
                                                     evaluator.general_admission_tickets_count)
    end
  end
end
