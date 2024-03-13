FactoryBot.define do
  factory :shopping_cart_ticket, class: "ShoppingCart::Ticket" do
    association :show_section, factory: :general_admission_show_section
    association :shopping_cart, factory: :shopping_cart
    quantity { 1 }
  end
end
