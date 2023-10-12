class CreateOrderMerch < ActiveRecord::Migration[7.1]
  def change
    create_table :order_merch do |t|
      t.references :merch, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.decimal :unit_price, null: false, precision: 10, scale: 2
      t.decimal :total_price, null: false, precision: 10, scale: 2
      t.string :option
      t.string :option_label

      t.timestamps
    end
  end
end
