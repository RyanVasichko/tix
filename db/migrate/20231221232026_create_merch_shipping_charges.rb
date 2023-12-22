class CreateMerchShippingCharges < ActiveRecord::Migration[7.1]
  def change
    create_table :merch_shipping_charges do |t|
      t.decimal :weight, precision: 8, scale: 2, null: false
      t.decimal :price, precision: 8, scale: 2, null: false

      t.timestamps
    end
  end
end
