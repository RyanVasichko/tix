class CreateMerch < ActiveRecord::Migration[7.0]
  def change
    create_table :merch do |t|
      t.decimal :price, null: false
      t.string :name, null: false, unique: true
      t.string :description
      t.boolean :active, null: false, default: true
      t.string :options
      t.string :option_label
      t.integer :order, null: false, default: 0

      t.timestamps
    end
  end
end
