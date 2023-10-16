class CreateCustomerQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :customer_questions do |t|
      t.text :question
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    create_join_table :shows, :customer_questions do |t|
      t.index :show_id
      t.index :customer_question_id
    end
  end
end
