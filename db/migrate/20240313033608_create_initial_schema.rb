class CreateInitialSchema < ActiveRecord::Migration[7.2]
  def change
    create_table :venues do |t|
      t.string :name, null: false
      t.boolean :active, null: false, default: true
      t.string :phone
      t.references :address, foreign_key: true
      t.decimal :sales_tax, precision: 4, scale: 2, default: "0.0", null: false

      t.timestamps
    end

    create_table :seating_charts do |t|
      t.string :name, null: false
      t.boolean :active, null: false, default: true
      t.boolean :published, null: false, default: true
      t.references :venue, null: false, foreign_key: true

      t.timestamps
    end

    create_table :ticket_types do |t|
      t.references :venue, null: false, foreign_key: true
      t.string :name, null: false
      t.decimal :convenience_fee, precision: 8, scale: 2
      t.string :convenience_fee_type, null: false
      t.decimal :default_price, null: false, precision: 8, scale: 2
      t.decimal :venue_commission, null: false, precision: 8, scale: 2
      t.boolean :dinner_included, null: false, default: false
      t.boolean :active, null: false, default: true
      t.string :payment_method, null: false

      t.timestamps
    end

    create_table :seating_chart_seats do |t|
      t.integer :x, null: false
      t.integer :y, null: false
      t.string :seat_number, null: false
      t.string :table_number, null: false
      t.references :seating_chart_section, null: false, foreign_key: true

      t.timestamps
    end

    create_table :seating_chart_sections do |t|
      t.string :name, null: false
      t.index [:name, :seating_chart_id]
      t.references :seating_chart, null: false, foreign_key: true
      t.references :ticket_type, null: false, foreign_key: true

      t.timestamps
    end

    create_table :shopping_carts do |t|
      t.timestamps
    end

    create_table :user_roles do |t|
      t.string :name, null: false
      t.boolean :hold_seats, default: false, null: false
      t.boolean :release_seats, default: false, null: false
      t.boolean :manage_customers, default: false, null: false
      t.boolean :manage_admins, default: false, null: false

      t.timestamps
    end

    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.string :password_digest
      t.string :type, null: false
      t.string :stripe_customer_id
      t.references :shopping_cart, null: false, foreign_key: true
      t.references :user_role, null: true, foreign_key: true
      t.string :shopper_uuid, null: false
      t.boolean :active, default: true, null: false
      t.index [:email, :active]
      t.index [:email], unique: true
      t.index [:shopper_uuid], unique: true

      t.check_constraint <<-SQL, name: 'check_user_information'
        (
           type != 'User::Guest'#{' '}
           AND first_name IS NOT NULL#{' '}
           AND last_name IS NOT NULL#{' '}
           AND email IS NOT NULL#{' '}
           AND password_digest IS NOT NULL
        )
        OR type = 'User::Guest'
      SQL

      t.check_constraint "type != 'User::Admin' OR user_role_id IS NOT NULL", name: 'check_admin_role'

      t.timestamps
    end

    create_table :artists do |t|
      t.string :name, null: false
      t.string :bio
      t.string :url
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    create_table :shows do |t|
      t.references :artist, null: false, foreign_key: true
      t.references :venue, null: false, foreign_key: true
      t.string :seating_chart_name
      t.datetime :show_date, null: false
      t.datetime :doors_open_at, null: false
      t.datetime :show_starts_at, null: false
      t.datetime :dinner_starts_at, null: false
      t.datetime :dinner_ends_at, null: false
      t.datetime :front_end_on_sale_at, null: false
      t.datetime :front_end_off_sale_at, null: false
      t.datetime :back_end_on_sale_at, null: false
      t.datetime :back_end_off_sale_at, null: false
      t.text :additional_text
      t.string :type, null: false
      t.date :original_date, null: false
      t.decimal :deposit_amount, precision: 8, scale: 2, null: false, default: 0

      t.timestamps
    end

    create_table :show_sections do |t|
      t.references :show, null: false, foreign_key: true
      t.decimal :ticket_price, precision: 10, scale: 2, null: false
      t.string :convenience_fee_type, null: false
      t.string :payment_method, null: false
      t.decimal :convenience_fee, precision: 10, scale: 2, null: false, default: 0
      t.decimal :venue_commission, precision: 10, scale: 2, null: false, default: 0
      t.integer :ticket_quantity
      t.string :name, null: false
      t.string :type, null: false

      t.timestamps
    end

    create_table :show_seats do |t|
      t.references :show_section, null: false, foreign_key: true
      t.integer :x, null: false
      t.integer :y, null: false
      t.integer :seat_number, null: false
      t.integer :table_number, null: true
      t.references :shopping_cart, null: true, foreign_key: true
      t.references :held_by_admin, null: true, foreign_key: { to_table: :users }
      t.datetime :reserved_until
      t.index %i[shopping_cart_id reserved_until]

      t.timestamps
    end

    create_table :order_payments do |t|
      t.string :stripe_payment_intent_id, null: false
      t.string :stripe_payment_method_id, null: false
      t.string :card_brand, null: false
      t.integer :card_exp_month, null: false
      t.integer :card_exp_year, null: false
      t.integer :card_last_4, null: false
      t.integer :amount_in_cents, null: false

      t.timestamps
    end

    create_table :orders do |t|
      t.decimal :order_total, null: false, precision: 8, scale: 2
      t.decimal :convenience_fees, null: false, default: 0, precision: 8, scale: 2
      t.decimal :shipping_fees, null: false, default: 0, precision: 8, scale: 2
      t.string :order_number
      t.references :orderer, polymorphic: true, null: false
      t.references :order_payment, foreign_key: true
      t.references :shipping_address, null: false, foreign_key: { to_table: :order_shipping_addresses }

      t.timestamps
    end

    create_table :order_tickets do |t|
      t.references :order, null: false, foreign_key: true
      t.references :show_seat, foreign_key: true
      t.references :show, null: false, foreign_key: true
      t.references :show_section, null: true, foreign_key: true
      t.integer :quantity, null: false, default: 1
      t.string :type, null: false
      t.decimal :convenience_fees, null: false, default: 0, precision: 8, scale: 2
      t.decimal :venue_commission, null: false, default: 0, precision: 8, scale: 2
      t.decimal :ticket_price, null: false, default: 0, precision: 8, scale: 2
      t.decimal :deposit_amount, null: false, default: 0, precision: 8, scale: 2
      t.decimal :total_price, null: false, default: 0, precision: 8, scale: 2

      t.timestamps
    end

    create_table :order_guest_orderers do |t|
      t.string :email, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone
      t.string :shopper_uuid, null: false

      t.timestamps
    end

    create_table :merch do |t|
      t.decimal :price, null: false
      t.string :name, null: false
      t.string :description
      t.boolean :active, null: false, default: true
      t.string :options
      t.string :option_label
      t.integer :order, null: false, default: 0
      t.decimal :weight, null: false, default: 0.0

      t.timestamps
    end

    create_table :merch_categories do |t|
      t.string :name, null: false

      t.timestamps
    end

    create_join_table :merch, :merch_categories do |t|
      t.index :merch_id
      t.index :merch_category_id
    end

    create_table :shopping_cart_merch do |t|
      t.references :merch, null: false, foreign_key: true
      t.references :shopping_cart, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.string :option

      t.timestamps
    end

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

    create_table :order_shipping_addresses do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.references :address, null: false

      t.timestamps
    end

    create_table :addresses do |t|
      t.string :address_1, null: false
      t.string :address_2
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip_code, null: false

      t.timestamps
    end

    create_table :customer_questions do |t|
      t.text :question
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    create_join_table :shows, :customer_questions do |t|
      t.index :show_id
      t.index :customer_question_id
    end

    create_table :show_upsales do |t|
      t.string :name, null: false
      t.text :description
      t.references :show, null: false, foreign_key: true
      t.decimal :price, precision: 8, scale: 2, null: false
      t.integer :quantity, null: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    create_table :shopping_cart_tickets do |t|
      t.references :show_section, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.references :shopping_cart, null: false, foreign_key: true

      t.timestamps
    end

    create_table :merch_shipping_charges do |t|
      t.decimal :weight, precision: 8, scale: 2, null: false
      t.decimal :price, precision: 8, scale: 2, null: false

      t.timestamps
    end

    # Remove the newlines because for some reason the newlines get persisted into structure.sql which breaks loading the schema
    execute <<~SQL.gsub("\n", '')
      CREATE VIRTUAL TABLE IF NOT EXISTS order_search_indices USING fts5(
        order_id,
        created_at,
        order_number,
        orderer_name,
        orderer_phone,
        orderer_email,
        order_total,
        artist_name,
        tickets_count,
        tokenize='trigram case_sensitive 0'
      );
    SQL
  end
end
