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

ActiveRecord::Schema[7.0].define(version: 2023_09_17_031603) do
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

  create_table "artists", force: :cascade do |t|
    t.string "name", null: false
    t.string "bio"
    t.string "url"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "order_tickets", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "show_seat_id", null: false
    t.bigint "show_id", null: false
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_tickets_on_order_id"
    t.index ["show_id"], name: "index_order_tickets_on_show_id"
    t.index ["show_seat_id"], name: "index_order_tickets_on_show_seat_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "order_total"
    t.string "order_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_payment_id"
    t.index ["order_payment_id"], name: "index_orders_on_order_payment_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
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
    t.string "name"
    t.bigint "seating_chart_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seating_chart_id"], name: "index_seating_chart_sections_on_seating_chart_id"
  end

  create_table "seating_charts", force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "show_seats", force: :cascade do |t|
    t.bigint "show_section_id", null: false
    t.integer "x"
    t.integer "y"
    t.integer "seat_number"
    t.integer "table_number"
    t.integer "reserved_by_id"
    t.datetime "reserved_until"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["show_section_id"], name: "index_show_seats_on_show_section_id"
  end

  create_table "show_sections", force: :cascade do |t|
    t.bigint "show_id", null: false
    t.decimal "ticket_price", precision: 10, scale: 2, null: false
    t.bigint "seating_chart_section_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seating_chart_section_id"], name: "index_show_sections_on_seating_chart_section_id"
    t.index ["show_id"], name: "index_show_sections_on_show_id"
  end

  create_table "shows", force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.bigint "seating_chart_id", null: false
    t.datetime "show_date"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_shows_on_artist_id"
    t.index ["seating_chart_id"], name: "index_shows_on_seating_chart_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "email"
    t.string "password_digest"
    t.string "type"
    t.string "stripe_customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.check_constraint "type::text <> 'User::Guest'::text AND first_name IS NOT NULL AND last_name IS NOT NULL AND email IS NOT NULL OR type::text = 'User::Guest'::text", name: "check_guest_fields"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "order_tickets", "orders"
  add_foreign_key "order_tickets", "show_seats"
  add_foreign_key "order_tickets", "shows"
  add_foreign_key "orders", "order_payments"
  add_foreign_key "orders", "users"
  add_foreign_key "seating_chart_seats", "seating_chart_sections"
  add_foreign_key "seating_chart_sections", "seating_charts"
  add_foreign_key "show_seats", "show_sections"
  add_foreign_key "show_sections", "seating_chart_sections"
  add_foreign_key "show_sections", "shows"
  add_foreign_key "shows", "artists"
  add_foreign_key "shows", "seating_charts"
end
