class CreateMerch < ActiveRecord::Migration[7.0]
  def change
    create_table :merch do |t|
      t.decimal :price, null: false
      t.string :name, null: false
      t.string :description
      t.boolean :active, default: true, null: false
      t.string :options, array: true, default: []
      t.string :option_label

      t.timestamps
    end
  end
end
