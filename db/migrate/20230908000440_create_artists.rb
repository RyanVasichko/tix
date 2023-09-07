class CreateArtists < ActiveRecord::Migration[7.0]
  def change
    create_table :artists do |t|
      t.string :name, null: false
      t.string :bio
      t.string :url
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
