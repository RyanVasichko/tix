class CreateOrderShippingAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :order_shipping_addresses do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.references :address, null: false

      t.timestamps
    end

    add_reference :orders, :shipping_address, foreign_key: { to_table: :order_shipping_addresses }
  end
end
