FactoryBot.define do
  factory :user_shopping_cart_ticket, class: 'User::ShoppingCart::Ticket' do
    association :show_section, factory: :general_admission_show_section
    association :shopping_cart, factory: :shopping_cart
    quantity { 1 }
  end
end
