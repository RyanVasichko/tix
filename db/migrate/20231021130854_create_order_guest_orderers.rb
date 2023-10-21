class CreateOrderGuestOrderers < ActiveRecord::Migration[7.1]
  def change
    create_table :order_guest_orderers do |t|
      t.string :email, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone
      t.uuid :shopper_uuid, null: false

      t.timestamps
    end
  end
end
