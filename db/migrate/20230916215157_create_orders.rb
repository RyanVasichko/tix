class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.decimal :order_total, null: false
      t.string :order_number
      t.references :orderer, polymorphic: true, null: false

      t.timestamps
    end
  end
end
