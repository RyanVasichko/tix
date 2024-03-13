CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "active_storage_attachments" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "record_type" varchar NOT NULL, "record_id" bigint NOT NULL, "blob_id" bigint NOT NULL, "created_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_c3b3935057"
FOREIGN KEY ("blob_id")
  REFERENCES "active_storage_blobs" ("id")
);
CREATE INDEX "index_active_storage_attachments_on_blob_id" ON "active_storage_attachments" ("blob_id");
CREATE UNIQUE INDEX "index_active_storage_attachments_uniqueness" ON "active_storage_attachments" ("record_type", "record_id", "name", "blob_id");
CREATE TABLE IF NOT EXISTS "active_storage_variant_records" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "blob_id" bigint NOT NULL, "variation_digest" varchar NOT NULL, CONSTRAINT "fk_rails_993965df05"
FOREIGN KEY ("blob_id")
  REFERENCES "active_storage_blobs" ("id")
);
CREATE UNIQUE INDEX "index_active_storage_variant_records_uniqueness" ON "active_storage_variant_records" ("blob_id", "variation_digest");
CREATE TABLE IF NOT EXISTS "active_storage_blobs" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "key" varchar NOT NULL, "filename" varchar NOT NULL, "content_type" varchar DEFAULT NULL, "metadata" text DEFAULT NULL, "service_name" varchar NOT NULL, "byte_size" bigint NOT NULL, "checksum" varchar DEFAULT NULL, "created_at" datetime(6) NOT NULL);
CREATE UNIQUE INDEX "index_active_storage_blobs_on_key" ON "active_storage_blobs" ("key");
CREATE TABLE IF NOT EXISTS "venues" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "active" boolean DEFAULT 1 NOT NULL, "phone" varchar, "address_id" integer, "sales_tax" decimal(4,2) DEFAULT 0.0 NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_07c8eb3ba9"
FOREIGN KEY ("address_id")
  REFERENCES "addresses" ("id")
);
CREATE INDEX "index_venues_on_address_id" ON "venues" ("address_id");
CREATE TABLE IF NOT EXISTS "seating_charts" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "active" boolean DEFAULT 1 NOT NULL, "published" boolean DEFAULT 1 NOT NULL, "venue_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_a9f101ac9d"
FOREIGN KEY ("venue_id")
  REFERENCES "venues" ("id")
);
CREATE INDEX "index_seating_charts_on_venue_id" ON "seating_charts" ("venue_id");
CREATE TABLE IF NOT EXISTS "ticket_types" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "venue_id" integer NOT NULL, "name" varchar NOT NULL, "convenience_fee" decimal(8,2), "convenience_fee_type" varchar NOT NULL, "default_price" decimal(8,2) NOT NULL, "venue_commission" decimal(8,2) NOT NULL, "dinner_included" boolean DEFAULT 0 NOT NULL, "active" boolean DEFAULT 1 NOT NULL, "payment_method" varchar NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_fefeeea69f"
FOREIGN KEY ("venue_id")
  REFERENCES "venues" ("id")
);
CREATE INDEX "index_ticket_types_on_venue_id" ON "ticket_types" ("venue_id");
CREATE TABLE IF NOT EXISTS "seating_chart_seats" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "x" integer NOT NULL, "y" integer NOT NULL, "seat_number" varchar NOT NULL, "table_number" varchar NOT NULL, "seating_chart_section_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_8adfff911b"
FOREIGN KEY ("seating_chart_section_id")
  REFERENCES "seating_chart_sections" ("id")
);
CREATE INDEX "index_seating_chart_seats_on_seating_chart_section_id" ON "seating_chart_seats" ("seating_chart_section_id");
CREATE TABLE IF NOT EXISTS "seating_chart_sections" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "seating_chart_id" integer NOT NULL, "ticket_type_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_fd7d12a305"
FOREIGN KEY ("seating_chart_id")
  REFERENCES "seating_charts" ("id")
, CONSTRAINT "fk_rails_d33a84c917"
FOREIGN KEY ("ticket_type_id")
  REFERENCES "ticket_types" ("id")
);
CREATE INDEX "index_seating_chart_sections_on_name_and_seating_chart_id" ON "seating_chart_sections" ("name", "seating_chart_id");
CREATE INDEX "index_seating_chart_sections_on_seating_chart_id" ON "seating_chart_sections" ("seating_chart_id");
CREATE INDEX "index_seating_chart_sections_on_ticket_type_id" ON "seating_chart_sections" ("ticket_type_id");
CREATE TABLE IF NOT EXISTS "user_shopping_carts" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "user_roles" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "hold_seats" boolean DEFAULT 0 NOT NULL, "release_seats" boolean DEFAULT 0 NOT NULL, "manage_customers" boolean DEFAULT 0 NOT NULL, "manage_admins" boolean DEFAULT 0 NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "users" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "first_name" varchar, "last_name" varchar, "phone" varchar, "email" varchar, "password_digest" varchar, "type" varchar NOT NULL, "stripe_customer_id" varchar, "user_shopping_cart_id" integer NOT NULL, "user_role_id" integer, "shopper_uuid" varchar NOT NULL, "active" boolean DEFAULT 1 NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_ccdc570bce"
FOREIGN KEY ("user_shopping_cart_id")
  REFERENCES "user_shopping_carts" ("id")
, CONSTRAINT "fk_rails_fa83e8f093"
FOREIGN KEY ("user_role_id")
  REFERENCES "user_roles" ("id")
, CONSTRAINT check_user_information CHECK (        (
           type != 'User::Guest' 
           AND first_name IS NOT NULL 
           AND last_name IS NOT NULL 
           AND email IS NOT NULL 
           AND password_digest IS NOT NULL
        )
        OR type = 'User::Guest'
), CONSTRAINT check_admin_role CHECK (type != 'User::Admin' OR user_role_id IS NOT NULL));
CREATE INDEX "index_users_on_user_shopping_cart_id" ON "users" ("user_shopping_cart_id");
CREATE INDEX "index_users_on_user_role_id" ON "users" ("user_role_id");
CREATE INDEX "index_users_on_email_and_active" ON "users" ("email", "active");
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email");
CREATE UNIQUE INDEX "index_users_on_shopper_uuid" ON "users" ("shopper_uuid");
CREATE TABLE IF NOT EXISTS "artists" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "bio" varchar, "url" varchar, "active" boolean DEFAULT 1 NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "shows" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "artist_id" integer NOT NULL, "venue_id" integer NOT NULL, "seating_chart_name" varchar, "show_date" datetime(6) NOT NULL, "doors_open_at" datetime(6) NOT NULL, "show_starts_at" datetime(6) NOT NULL, "dinner_starts_at" datetime(6) NOT NULL, "dinner_ends_at" datetime(6) NOT NULL, "front_end_on_sale_at" datetime(6) NOT NULL, "front_end_off_sale_at" datetime(6) NOT NULL, "back_end_on_sale_at" datetime(6) NOT NULL, "back_end_off_sale_at" datetime(6) NOT NULL, "additional_text" text, "type" varchar NOT NULL, "original_date" date NOT NULL, "deposit_amount" decimal(8,2) DEFAULT 0.0 NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_96c68eaa51"
FOREIGN KEY ("artist_id")
  REFERENCES "artists" ("id")
, CONSTRAINT "fk_rails_ae9094c3e4"
FOREIGN KEY ("venue_id")
  REFERENCES "venues" ("id")
);
CREATE INDEX "index_shows_on_artist_id" ON "shows" ("artist_id");
CREATE INDEX "index_shows_on_venue_id" ON "shows" ("venue_id");
CREATE TABLE IF NOT EXISTS "show_sections" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "show_id" integer NOT NULL, "ticket_price" decimal(10,2) NOT NULL, "convenience_fee_type" varchar NOT NULL, "payment_method" varchar NOT NULL, "convenience_fee" decimal(10,2) DEFAULT 0.0 NOT NULL, "venue_commission" decimal(10,2) DEFAULT 0.0 NOT NULL, "ticket_quantity" integer, "name" varchar NOT NULL, "type" varchar NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_1780aa424a"
FOREIGN KEY ("show_id")
  REFERENCES "shows" ("id")
);
CREATE INDEX "index_show_sections_on_show_id" ON "show_sections" ("show_id");
CREATE TABLE IF NOT EXISTS "show_seats" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "show_section_id" integer NOT NULL, "x" integer NOT NULL, "y" integer NOT NULL, "seat_number" integer NOT NULL, "table_number" integer, "user_shopping_cart_id" integer, "held_by_admin_id" integer, "reserved_until" datetime(6), "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_d00b4b7099"
FOREIGN KEY ("show_section_id")
  REFERENCES "show_sections" ("id")
, CONSTRAINT "fk_rails_65c10f4625"
FOREIGN KEY ("user_shopping_cart_id")
  REFERENCES "user_shopping_carts" ("id")
, CONSTRAINT "fk_rails_7f3cf83063"
FOREIGN KEY ("held_by_admin_id")
  REFERENCES "users" ("id")
);
CREATE INDEX "index_show_seats_on_show_section_id" ON "show_seats" ("show_section_id");
CREATE INDEX "index_show_seats_on_user_shopping_cart_id" ON "show_seats" ("user_shopping_cart_id");
CREATE INDEX "index_show_seats_on_held_by_admin_id" ON "show_seats" ("held_by_admin_id");
CREATE INDEX "index_show_seats_on_user_shopping_cart_id_and_reserved_until" ON "show_seats" ("user_shopping_cart_id", "reserved_until");
CREATE TABLE IF NOT EXISTS "order_payments" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "stripe_payment_intent_id" varchar NOT NULL, "stripe_payment_method_id" varchar NOT NULL, "card_brand" varchar NOT NULL, "card_exp_month" integer NOT NULL, "card_exp_year" integer NOT NULL, "card_last_4" integer NOT NULL, "amount_in_cents" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "orders" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "order_total" decimal(8,2) NOT NULL, "convenience_fees" decimal(8,2) DEFAULT 0.0 NOT NULL, "shipping_fees" decimal(8,2) DEFAULT 0.0 NOT NULL, "order_number" varchar, "orderer_type" varchar NOT NULL, "orderer_id" integer NOT NULL, "order_payment_id" integer, "shipping_address_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_93fa66ee37"
FOREIGN KEY ("order_payment_id")
  REFERENCES "order_payments" ("id")
, CONSTRAINT "fk_rails_267c198c1b"
FOREIGN KEY ("shipping_address_id")
  REFERENCES "order_shipping_addresses" ("id")
);
CREATE INDEX "index_orders_on_orderer" ON "orders" ("orderer_type", "orderer_id");
CREATE INDEX "index_orders_on_order_payment_id" ON "orders" ("order_payment_id");
CREATE INDEX "index_orders_on_shipping_address_id" ON "orders" ("shipping_address_id");
CREATE TABLE IF NOT EXISTS "order_tickets" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "order_id" integer NOT NULL, "show_seat_id" integer, "show_id" integer NOT NULL, "show_section_id" integer, "quantity" integer DEFAULT 1 NOT NULL, "type" varchar NOT NULL, "convenience_fees" decimal(8,2) DEFAULT 0.0 NOT NULL, "venue_commission" decimal(8,2) DEFAULT 0.0 NOT NULL, "ticket_price" decimal(8,2) DEFAULT 0.0 NOT NULL, "deposit_amount" decimal(8,2) DEFAULT 0.0 NOT NULL, "total_price" decimal(8,2) DEFAULT 0.0 NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_4dd45aa50c"
FOREIGN KEY ("order_id")
  REFERENCES "orders" ("id")
, CONSTRAINT "fk_rails_b05a619665"
FOREIGN KEY ("show_seat_id")
  REFERENCES "show_seats" ("id")
, CONSTRAINT "fk_rails_8adea9a79c"
FOREIGN KEY ("show_id")
  REFERENCES "shows" ("id")
, CONSTRAINT "fk_rails_666e9f9c5d"
FOREIGN KEY ("show_section_id")
  REFERENCES "show_sections" ("id")
);
CREATE INDEX "index_order_tickets_on_order_id" ON "order_tickets" ("order_id");
CREATE INDEX "index_order_tickets_on_show_seat_id" ON "order_tickets" ("show_seat_id");
CREATE INDEX "index_order_tickets_on_show_id" ON "order_tickets" ("show_id");
CREATE INDEX "index_order_tickets_on_show_section_id" ON "order_tickets" ("show_section_id");
CREATE TABLE IF NOT EXISTS "order_guest_orderers" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar NOT NULL, "first_name" varchar NOT NULL, "last_name" varchar NOT NULL, "phone" varchar, "shopper_uuid" varchar NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "merch" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "price" decimal NOT NULL, "name" varchar NOT NULL, "description" varchar, "active" boolean DEFAULT 1 NOT NULL, "options" varchar, "option_label" varchar, "order" integer DEFAULT 0 NOT NULL, "weight" decimal DEFAULT 0.0 NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "merch_categories" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "merch_merch_categories" ("merch_id" integer NOT NULL, "merch_category_id" integer NOT NULL);
CREATE INDEX "index_merch_merch_categories_on_merch_id" ON "merch_merch_categories" ("merch_id");
CREATE INDEX "index_merch_merch_categories_on_merch_category_id" ON "merch_merch_categories" ("merch_category_id");
CREATE TABLE IF NOT EXISTS "user_shopping_cart_merch" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "merch_id" integer NOT NULL, "user_shopping_cart_id" integer NOT NULL, "quantity" integer NOT NULL, "option" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_14f2b9242a"
FOREIGN KEY ("merch_id")
  REFERENCES "merch" ("id")
, CONSTRAINT "fk_rails_3b52ad1d22"
FOREIGN KEY ("user_shopping_cart_id")
  REFERENCES "user_shopping_carts" ("id")
);
CREATE INDEX "index_user_shopping_cart_merch_on_merch_id" ON "user_shopping_cart_merch" ("merch_id");
CREATE INDEX "index_user_shopping_cart_merch_on_user_shopping_cart_id" ON "user_shopping_cart_merch" ("user_shopping_cart_id");
CREATE TABLE IF NOT EXISTS "order_merch" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "merch_id" integer NOT NULL, "order_id" integer NOT NULL, "quantity" integer NOT NULL, "unit_price" decimal(10,2) NOT NULL, "total_price" decimal(10,2) NOT NULL, "option" varchar, "option_label" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_5033407e09"
FOREIGN KEY ("merch_id")
  REFERENCES "merch" ("id")
, CONSTRAINT "fk_rails_68fac84bdc"
FOREIGN KEY ("order_id")
  REFERENCES "orders" ("id")
);
CREATE INDEX "index_order_merch_on_merch_id" ON "order_merch" ("merch_id");
CREATE INDEX "index_order_merch_on_order_id" ON "order_merch" ("order_id");
CREATE TABLE IF NOT EXISTS "order_shipping_addresses" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "first_name" varchar NOT NULL, "last_name" varchar NOT NULL, "address_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE INDEX "index_order_shipping_addresses_on_address_id" ON "order_shipping_addresses" ("address_id");
CREATE TABLE IF NOT EXISTS "addresses" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "address_1" varchar NOT NULL, "address_2" varchar, "city" varchar NOT NULL, "state" varchar NOT NULL, "zip_code" varchar NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "customer_questions" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "question" text, "active" boolean DEFAULT 1 NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "customer_questions_shows" ("show_id" integer NOT NULL, "customer_question_id" integer NOT NULL);
CREATE INDEX "index_customer_questions_shows_on_show_id" ON "customer_questions_shows" ("show_id");
CREATE INDEX "index_customer_questions_shows_on_customer_question_id" ON "customer_questions_shows" ("customer_question_id");
CREATE TABLE IF NOT EXISTS "show_upsales" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "description" text, "show_id" integer NOT NULL, "price" decimal(8,2) NOT NULL, "quantity" integer NOT NULL, "active" boolean DEFAULT 1 NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_a59a83fda7"
FOREIGN KEY ("show_id")
  REFERENCES "shows" ("id")
);
CREATE INDEX "index_show_upsales_on_show_id" ON "show_upsales" ("show_id");
CREATE TABLE IF NOT EXISTS "user_shopping_cart_tickets" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "show_section_id" integer NOT NULL, "quantity" integer NOT NULL, "user_shopping_cart_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_c722d48ae2"
FOREIGN KEY ("show_section_id")
  REFERENCES "show_sections" ("id")
, CONSTRAINT "fk_rails_2771fee292"
FOREIGN KEY ("user_shopping_cart_id")
  REFERENCES "user_shopping_carts" ("id")
);
CREATE INDEX "index_user_shopping_cart_tickets_on_show_section_id" ON "user_shopping_cart_tickets" ("show_section_id");
CREATE INDEX "index_user_shopping_cart_tickets_on_user_shopping_cart_id" ON "user_shopping_cart_tickets" ("user_shopping_cart_id");
CREATE TABLE IF NOT EXISTS "merch_shipping_charges" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "weight" decimal(8,2) NOT NULL, "price" decimal(8,2) NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE VIRTUAL TABLE order_search_indices USING fts5(  order_id,  created_at,  order_number,  orderer_name,  orderer_phone,  orderer_email,  order_total,  artist_name,  tickets_count,  tokenize='trigram case_sensitive 0')
/* order_search_indices(order_id,created_at,order_number,orderer_name,orderer_phone,orderer_email,order_total,artist_name,tickets_count) */;
CREATE TABLE IF NOT EXISTS 'order_search_indices_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'order_search_indices_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'order_search_indices_content'(id INTEGER PRIMARY KEY, c0, c1, c2, c3, c4, c5, c6, c7, c8);
CREATE TABLE IF NOT EXISTS 'order_search_indices_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'order_search_indices_config'(k PRIMARY KEY, v) WITHOUT ROWID;
INSERT INTO "schema_migrations" (version) VALUES
('20240313033608'),
('20231013021917'),
('20231013021916'),
('20231013021915'),
('20230831025140');

