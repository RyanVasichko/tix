# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_11_07_171214) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "address_1", null: false
    t.string "address_2"
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "artists", force: :cascade do |t|
    t.string "name", null: false
    t.string "bio"
    t.string "url"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customer_questions", force: :cascade do |t|
    t.text "question"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customer_questions_shows", id: false, force: :cascade do |t|
    t.bigint "show_id", null: false
    t.bigint "customer_question_id", null: false
    t.index ["customer_question_id"], name: "index_customer_questions_shows_on_customer_question_id"
    t.index ["show_id"], name: "index_customer_questions_shows_on_show_id"
  end

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.jsonb "serialized_properties"
    t.text "on_finish"
    t.text "on_success"
    t.text "on_discard"
    t.text "callback_queue_name"
    t.integer "callback_priority"
    t.datetime "enqueued_at"
    t.datetime "discarded_at"
    t.datetime "finished_at"
  end

  create_table "good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id", null: false
    t.text "job_class"
    t.text "queue_name"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.text "error"
    t.integer "error_event", limit: 2
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.uuid "batch_id"
    t.uuid "batch_callback_id"
    t.boolean "is_discrete"
    t.integer "executions_count"
    t.text "job_class"
    t.integer "error_event", limit: 2
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["active_job_id"], name: "index_good_jobs_on_active_job_id"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at", unique: true
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "merch", force: :cascade do |t|
    t.decimal "price", null: false
    t.string "name", null: false
    t.string "description"
    t.boolean "active", default: true, null: false
    t.string "options", default: [], array: true
    t.string "option_label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "merch_categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "merch_merch_categories", id: false, force: :cascade do |t|
    t.bigint "merch_id", null: false
    t.bigint "merch_category_id", null: false
    t.index ["merch_category_id"], name: "index_merch_merch_categories_on_merch_category_id"
    t.index ["merch_id"], name: "index_merch_merch_categories_on_merch_id"
  end

  create_table "order_guest_orderers", force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone"
    t.uuid "shopper_uuid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_merch", force: :cascade do |t|
    t.bigint "merch_id", null: false
    t.bigint "order_id", null: false
    t.integer "quantity", null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.decimal "total_price", precision: 10, scale: 2, null: false
    t.string "option"
    t.string "option_label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merch_id"], name: "index_order_merch_on_merch_id"
    t.index ["order_id"], name: "index_order_merch_on_order_id"
  end

  create_table "order_payments", force: :cascade do |t|
    t.string "stripe_payment_intent_id", null: false
    t.string "stripe_payment_method_id", null: false
    t.string "card_brand", null: false
    t.integer "card_exp_month", null: false
    t.integer "card_exp_year", null: false
    t.integer "card_last_4", null: false
    t.integer "amount_in_cents", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_shipping_addresses", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.bigint "address_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_order_shipping_addresses_on_address_id"
  end

  create_table "order_tickets", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "show_seat_id", null: false
    t.bigint "show_id", null: false
    t.decimal "convenience_fees", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "venue_commission", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "ticket_price", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "total_price", precision: 8, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_tickets_on_order_id"
    t.index ["show_id"], name: "index_order_tickets_on_show_id"
    t.index ["show_seat_id"], name: "index_order_tickets_on_show_seat_id"
  end

  create_table "orders", force: :cascade do |t|
    t.decimal "order_total", null: false
    t.string "order_number"
    t.string "orderer_type", null: false
    t.bigint "orderer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_payment_id"
    t.bigint "shipping_address_id"
    t.index ["order_payment_id"], name: "index_orders_on_order_payment_id"
    t.index ["orderer_type", "orderer_id"], name: "index_orders_on_orderer"
    t.index ["shipping_address_id"], name: "index_orders_on_shipping_address_id"
  end

  create_table "seating_chart_seats", force: :cascade do |t|
    t.integer "x", null: false
    t.integer "y", null: false
    t.string "seat_number", null: false
    t.string "table_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "seating_chart_section_id", null: false
    t.index ["seating_chart_section_id"], name: "index_seating_chart_seats_on_seating_chart_section_id"
  end

  create_table "seating_chart_sections", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "seating_chart_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "ticket_type_id", null: false
    t.index ["name", "seating_chart_id"], name: "index_seating_chart_sections_on_name_and_seating_chart_id", unique: true
    t.index ["seating_chart_id"], name: "index_seating_chart_sections_on_seating_chart_id"
    t.index ["ticket_type_id"], name: "index_seating_chart_sections_on_ticket_type_id"
  end

  create_table "seating_charts", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "venue_id"
    t.index ["venue_id"], name: "index_seating_charts_on_venue_id"
  end

  create_table "show_seats", force: :cascade do |t|
    t.bigint "show_section_id", null: false
    t.integer "x", null: false
    t.integer "y", null: false
    t.integer "seat_number", null: false
    t.integer "table_number"
    t.bigint "user_shopping_cart_id"
    t.datetime "reserved_until"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["show_section_id"], name: "index_show_seats_on_show_section_id"
    t.index ["user_shopping_cart_id"], name: "index_show_seats_on_user_shopping_cart_id"
  end

  create_table "show_sections", force: :cascade do |t|
    t.bigint "show_id", null: false
    t.decimal "ticket_price", precision: 10, scale: 2, null: false
    t.integer "convenience_fee_type", null: false
    t.integer "payment_method", null: false
    t.decimal "convenience_fee", precision: 10, scale: 2, null: false
    t.decimal "venue_commission", precision: 10, scale: 2, null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["show_id"], name: "index_show_sections_on_show_id"
  end

  create_table "show_upsales", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "show_id", null: false
    t.decimal "price", precision: 8, scale: 2, null: false
    t.integer "quantity", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "show_id"], name: "index_show_upsales_on_name_and_show_id", unique: true
    t.index ["show_id"], name: "index_show_upsales_on_show_id"
  end

  create_table "shows", force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.string "seating_chart_name", null: false
    t.datetime "show_date", null: false
    t.datetime "doors_open_at", null: false
    t.datetime "show_starts_at", null: false
    t.datetime "dinner_starts_at", null: false
    t.datetime "dinner_ends_at", null: false
    t.datetime "front_end_on_sale_at", null: false
    t.datetime "front_end_off_sale_at", null: false
    t.datetime "back_end_on_sale_at", null: false
    t.datetime "back_end_off_sale_at", null: false
    t.text "additional_text"
    t.decimal "deposit_amount", precision: 8, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "venue_id"
    t.index ["artist_id"], name: "index_shows_on_artist_id"
    t.index ["venue_id"], name: "index_shows_on_venue_id"
  end

  create_table "ticket_types", force: :cascade do |t|
    t.bigint "venue_id", null: false
    t.string "name", null: false
    t.decimal "convenience_fee", precision: 8, scale: 2
    t.integer "convenience_fee_type", null: false
    t.decimal "default_price", precision: 8, scale: 2, null: false
    t.decimal "venue_commission", precision: 8, scale: 2, null: false
    t.boolean "dinner_included", default: false, null: false
    t.boolean "active", default: true, null: false
    t.integer "payment_method", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["venue_id"], name: "index_ticket_types_on_venue_id"
  end

  create_table "user_shopping_cart_merch", force: :cascade do |t|
    t.bigint "merch_id", null: false
    t.bigint "user_shopping_cart_id", null: false
    t.integer "quantity", null: false
    t.string "option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merch_id"], name: "index_user_shopping_cart_merch_on_merch_id"
    t.index ["user_shopping_cart_id"], name: "index_user_shopping_cart_merch_on_user_shopping_cart_id"
  end

  create_table "user_shopping_carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "email"
    t.string "password_digest"
    t.string "type", null: false
    t.string "stripe_customer_id"
    t.bigint "user_shopping_cart_id", null: false
    t.uuid "shopper_uuid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_shopping_cart_id"], name: "index_users_on_user_shopping_cart_id"
    t.check_constraint "type::text <> 'User::Guest'::text AND first_name IS NOT NULL AND last_name IS NOT NULL AND email IS NOT NULL AND password_digest IS NOT NULL OR type::text = 'User::Guest'::text", name: "check_guest_fields"
  end

  create_table "venues", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "order_merch", "merch"
  add_foreign_key "order_merch", "orders"
  add_foreign_key "order_tickets", "orders"
  add_foreign_key "order_tickets", "show_seats"
  add_foreign_key "order_tickets", "shows"
  add_foreign_key "orders", "order_payments"
  add_foreign_key "orders", "order_shipping_addresses", column: "shipping_address_id"
  add_foreign_key "seating_chart_seats", "seating_chart_sections"
  add_foreign_key "seating_chart_sections", "seating_charts"
  add_foreign_key "seating_chart_sections", "ticket_types"
  add_foreign_key "seating_charts", "venues"
  add_foreign_key "show_seats", "show_sections"
  add_foreign_key "show_seats", "user_shopping_carts"
  add_foreign_key "show_sections", "shows"
  add_foreign_key "show_upsales", "shows"
  add_foreign_key "shows", "artists"
  add_foreign_key "shows", "venues"
  add_foreign_key "ticket_types", "venues"
  add_foreign_key "user_shopping_cart_merch", "merch"
  add_foreign_key "user_shopping_cart_merch", "user_shopping_carts"
  add_foreign_key "users", "user_shopping_carts"
end
