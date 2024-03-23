FactoryBot.define do
  factory :shopping_cart, class: "ShoppingCart" do
    transient do
      merch_count { 0 }
      reserved_seats_count { 0 }
      general_admission_tickets_count { 0 }
    end

    after(:build) do |shopping_cart, evaluator|
      shopping_cart.selections << FactoryBot.build_list(:shopping_cart_merch_selection,
                                                        evaluator.merch_count,
                                                        quantity: 1)

      shopping_cart.selections << FactoryBot.build_list(:shopping_cart_general_admission_ticket_selection,
                                                        evaluator.general_admission_tickets_count,
                                                        quantity: 1)

      shopping_cart.selections << FactoryBot.build_list(:shopping_cart_reserved_seating_ticket_selection,
                                                        evaluator.reserved_seats_count,
                                                        expires_at: 15.minutes.from_now,
                                                        quantity: 1)
    end
  end
end
