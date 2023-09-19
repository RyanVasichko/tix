class CreateOrderPayments < ActiveRecord::Migration[7.0]
  def change
    create_table :order_payments do |t|
      t.string :stripe_payment_intent_id, null: false
      t.string :stripe_payment_method_id, null: false
      t.string :card_brand, null: false
      t.integer :card_exp_month, null: false
      t.integer :card_exp_year, null: false
      t.integer :card_last_4, null: false
      t.integer :amount_in_cents, null: false

      t.timestamps
    end

    add_reference :orders, :order_payment, index: true, foreign_key: { to_table: :order_payments }
  end
end
