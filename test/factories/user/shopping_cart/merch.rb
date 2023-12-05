FactoryBot.define do
  factory :shopping_cart_merch, class: "User::ShoppingCart::Merch" do
    association :merch
    association :shopping_cart
    quantity { rand(1..5) }

    after(:build) do |shopping_cart_merch|
      shopping_cart_merch.option = shopping_cart_merch.merch.options.sample
    end
  end
end
