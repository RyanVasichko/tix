FactoryBot.define do
  factory :order_payment, class: 'Order::Payment' do
    association :order

    stripe_payment_intent_id { Faker::Alphanumeric.unique.alphanumeric(number: 24) }
    stripe_payment_method_id { Faker::Alphanumeric.unique.alphanumeric(number: 24) }
    card_brand { %w[Visa MasterCard Amex Discover].sample }
    card_exp_month { Faker::Number.between(from: 1, to: 12) }
    card_exp_year { Faker::Number.between(from: 2023, to: 2030) }
    card_last_4 { Faker::Number.number(digits: 4) }
    amount_in_cents { Faker::Number.between(from: 100, to: 100000) }
  end
end
