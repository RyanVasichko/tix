FactoryBot.define do
  trait :shopping_cart_selection do
    quantity { 1 }
    options { {} }
    shopping_cart { nil }

    after(:build) do |selection, evaluator|
      selection.shopping_cart ||= FactoryBot.build(:shopping_cart, selections: [selection])
    end
  end

  factory :shopping_cart_merch_selection, class: "ShoppingCart::Selection", traits: %i[shopping_cart_selection] do
    association :selectable, factory: :merch
  end

  factory :shopping_cart_general_admission_ticket_selection, class: "ShoppingCart::Selection", traits: %i[shopping_cart_selection] do
    association :selectable, factory: :general_admission_ticket
  end

  factory :shopping_cart_reserved_seating_ticket_selection, class: "ShoppingCart::Selection", traits: %i[shopping_cart_selection] do
    association :selectable, factory: :reserved_seating_ticket
  end
end
