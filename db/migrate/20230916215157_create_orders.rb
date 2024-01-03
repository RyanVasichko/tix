class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.decimal :order_total, null: false, precision: 8, scale: 2
      t.decimal :convenience_fees, null: false, default: 0, precision: 8, scale: 2
      t.decimal :shipping_fees, null: false, default: 0, precision: 8, scale: 2
      t.string :order_number
      t.references :orderer, polymorphic: true, null: false

      t.timestamps
    end
  end
end
