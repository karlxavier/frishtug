# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180508061053) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "add_ons", force: :cascade do |t|
    t.string "name"
    t.bigint "menu_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "menu_id"
    t.index ["menu_category_id"], name: "index_add_ons_on_menu_category_id"
    t.index ["menu_id"], name: "index_add_ons_on_menu_id"
  end

  create_table "add_ons_menus", force: :cascade do |t|
    t.bigint "add_on_id"
    t.bigint "menu_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["add_on_id"], name: "index_add_ons_menus_on_add_on_id"
    t.index ["menu_id"], name: "index_add_ons_menus_on_menu_id"
  end

  create_table "addresses", force: :cascade do |t|
    t.string "line1"
    t.string "line2"
    t.string "front_door"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "addressable_type"
    t.bigint "addressable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "location_at"
    t.integer "status"
    t.float "latitude"
    t.float "longitude"
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "allowed_zip_codes", force: :cascade do |t|
    t.string "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "store_id"
    t.index ["store_id"], name: "index_allowed_zip_codes_on_store_id"
    t.index ["zip"], name: "index_allowed_zip_codes_on_zip"
  end

  create_table "assets", force: :cascade do |t|
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_name"
    t.index ["file_name"], name: "index_assets_on_file_name"
  end

  create_table "assets_stores", force: :cascade do |t|
    t.bigint "store_id"
    t.bigint "asset_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_id"], name: "index_assets_stores_on_asset_id"
    t.index ["store_id"], name: "index_assets_stores_on_store_id"
  end

  create_table "bill_histories", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "user_id"
    t.decimal "amount_paid", precision: 8, scale: 2
    t.datetime "billed_at"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_bill_histories_on_order_id"
    t.index ["user_id"], name: "index_bill_histories_on_user_id"
  end

  create_table "blackout_dates", force: :cascade do |t|
    t.string "month"
    t.integer "day"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "candidates", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "referrer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["referrer_id"], name: "index_candidates_on_referrer_id"
    t.index ["user_id"], name: "index_candidates_on_user_id"
  end

  create_table "checkings", force: :cascade do |t|
    t.string "bank_name"
    t.string "account_number"
    t.string "routing_number"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.string "stripe_id"
    t.index ["stripe_id"], name: "index_checkings_on_stripe_id"
    t.index ["token"], name: "index_checkings_on_token"
    t.index ["user_id"], name: "index_checkings_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id"
    t.text "body"
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contact_numbers", force: :cascade do |t|
    t.string "phone_number"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_contact_numbers_on_user_id"
  end

  create_table "credit_cards", force: :cascade do |t|
    t.string "number"
    t.integer "month", limit: 2
    t.integer "year", limit: 2
    t.integer "cvc"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "brand"
    t.string "token"
    t.string "name"
    t.string "stripe_id"
    t.index ["stripe_id"], name: "index_credit_cards_on_stripe_id"
    t.index ["token"], name: "index_credit_cards_on_token"
    t.index ["user_id"], name: "index_credit_cards_on_user_id"
  end

  create_table "diet_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "diet_categories_menus", force: :cascade do |t|
    t.bigint "diet_category_id"
    t.bigint "menu_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["diet_category_id"], name: "index_diet_categories_menus_on_diet_category_id"
    t.index ["menu_id"], name: "index_diet_categories_menus_on_menu_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inactive_users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventories", force: :cascade do |t|
    t.bigint "menu_id"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "inventory_id"
    t.integer "quantity"
    t.index ["inventory_id"], name: "index_inventories_on_inventory_id"
    t.index ["menu_id"], name: "index_inventories_on_menu_id"
  end

  create_table "inventory_transactions", force: :cascade do |t|
    t.bigint "inventory_id"
    t.integer "quantity_sold"
    t.datetime "transaction_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity_on_hand"
    t.index ["inventory_id"], name: "index_inventory_transactions_on_inventory_id"
  end

  create_table "menu_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "display_order"
    t.boolean "part_of_plan", default: true
    t.index ["display_order"], name: "index_menu_categories_on_display_order"
    t.index ["part_of_plan"], name: "index_menu_categories_on_part_of_plan"
  end

  create_table "menus", force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 8, scale: 2
    t.bigint "unit_id"
    t.bigint "menu_category_id"
    t.datetime "published_at"
    t.boolean "published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "unit_size"
    t.string "item_number"
    t.boolean "tax", default: false
    t.text "description"
    t.bigint "asset_id"
    t.string "notes"
    t.index ["asset_id"], name: "index_menus_on_asset_id"
    t.index ["item_number"], name: "index_menus_on_item_number", unique: true
    t.index ["menu_category_id"], name: "index_menus_on_menu_category_id"
    t.index ["unit_id"], name: "index_menus_on_unit_id"
  end

  create_table "menus_orders", force: :cascade do |t|
    t.bigint "menu_id"
    t.bigint "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity"
    t.string "add_ons", default: [], array: true
    t.index ["menu_id"], name: "index_menus_orders_on_menu_id"
    t.index ["order_id"], name: "index_menus_orders_on_order_id"
  end

  create_table "menus_temp_orders", force: :cascade do |t|
    t.bigint "menu_id"
    t.bigint "temp_order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity", default: 0
    t.string "add_ons", default: [], array: true
    t.index ["menu_id"], name: "index_menus_temp_orders_on_menu_id"
    t.index ["temp_order_id"], name: "index_menus_temp_orders_on_temp_order_id"
  end

  create_table "nutritional_data", force: :cascade do |t|
    t.bigint "menu_id"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_id"], name: "index_nutritional_data_on_menu_id"
  end

  create_table "order_preferences", force: :cascade do |t|
    t.boolean "copy_menu"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_order_preferences_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "placed_on"
    t.string "eta"
    t.datetime "delivered_at"
    t.integer "status"
    t.string "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "order_date"
    t.integer "series_number"
    t.string "sku"
    t.integer "delivery_status"
    t.string "payment_details"
    t.string "route_started"
    t.integer "payment_status"
    t.index ["order_date"], name: "index_orders_on_order_date"
    t.index ["series_number"], name: "index_orders_on_series_number"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "pending_credits", force: :cascade do |t|
    t.decimal "amount", precision: 8, scale: 2
    t.datetime "activation_date"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "placed_on_date"
    t.bigint "order_id"
    t.index ["order_id"], name: "index_pending_credits_on_order_id"
    t.index ["user_id"], name: "index_pending_credits_on_user_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price", precision: 8, scale: 2
    t.integer "shipping"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "shipping_fee", precision: 8, scale: 2
    t.text "note"
    t.string "shipping_note"
    t.string "stripe_plan_id"
    t.string "interval"
    t.integer "users_count", default: 0
    t.string "for_type"
    t.string "short_description", limit: 150
    t.decimal "limit", precision: 8, scale: 2
    t.decimal "minimum_credit_allowed", precision: 8, scale: 2
    t.index ["stripe_plan_id"], name: "index_plans_on_stripe_plan_id"
  end

  create_table "referrers", force: :cascade do |t|
    t.bigint "user_id"
    t.string "group_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_referrers_on_user_id"
  end

  create_table "registration_inputs", force: :cascade do |t|
    t.string "sid"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sid"], name: "index_registration_inputs_on_sid"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "option"
    t.datetime "start_date"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_schedules_on_user_id"
  end

  create_table "shipping_charges", force: :cascade do |t|
    t.bigint "order_id"
    t.string "charge_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_shipping_charges_on_order_id"
  end

  create_table "stores", force: :cascade do |t|
    t.integer "_id"
    t.string "_code"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "home_page_images"
  end

  create_table "suggestion_complaints", force: :cascade do |t|
    t.string "email"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "type", default: 1
  end

  create_table "taxes", force: :cascade do |t|
    t.float "rate"
    t.bigint "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_taxes_on_store_id"
  end

  create_table "temp_orders", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "order_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_temp_orders_on_user_id"
  end

  create_table "units", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_notifications", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "timeout"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uniq_id"
    t.index ["uniq_id"], name: "index_user_notifications_on_uniq_id"
    t.index ["user_id"], name: "index_user_notifications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.bigint "plan_id"
    t.string "stripe_token"
    t.datetime "subscribe_at"
    t.datetime "subscription_expires_at"
    t.string "stripe_customer_id"
    t.string "stripe_subscription_id"
    t.boolean "approved", default: false, null: false
    t.index ["approved"], name: "index_users_on_approved"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["first_name"], name: "index_users_on_first_name"
    t.index ["last_name"], name: "index_users_on_last_name"
    t.index ["plan_id"], name: "index_users_on_plan_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["stripe_customer_id"], name: "index_users_on_stripe_customer_id"
    t.index ["stripe_subscription_id"], name: "index_users_on_stripe_subscription_id"
    t.index ["stripe_token"], name: "index_users_on_stripe_token"
    t.index ["subscribe_at"], name: "index_users_on_subscribe_at"
    t.index ["subscription_expires_at"], name: "index_users_on_subscription_expires_at"
  end

  add_foreign_key "add_ons", "menu_categories"
  add_foreign_key "add_ons", "menus"
  add_foreign_key "add_ons_menus", "add_ons"
  add_foreign_key "add_ons_menus", "menus"
  add_foreign_key "allowed_zip_codes", "stores"
  add_foreign_key "assets_stores", "assets"
  add_foreign_key "assets_stores", "stores"
  add_foreign_key "bill_histories", "orders"
  add_foreign_key "bill_histories", "users"
  add_foreign_key "candidates", "referrers"
  add_foreign_key "candidates", "users"
  add_foreign_key "checkings", "users"
  add_foreign_key "comments", "users"
  add_foreign_key "contact_numbers", "users"
  add_foreign_key "credit_cards", "users"
  add_foreign_key "inventories", "menus"
  add_foreign_key "inventory_transactions", "inventories"
  add_foreign_key "menus", "assets"
  add_foreign_key "menus", "menu_categories"
  add_foreign_key "menus", "units"
  add_foreign_key "menus_orders", "menus"
  add_foreign_key "menus_orders", "orders"
  add_foreign_key "menus_temp_orders", "menus"
  add_foreign_key "menus_temp_orders", "temp_orders"
  add_foreign_key "nutritional_data", "menus"
  add_foreign_key "order_preferences", "users"
  add_foreign_key "orders", "users"
  add_foreign_key "pending_credits", "orders"
  add_foreign_key "pending_credits", "users"
  add_foreign_key "referrers", "users"
  add_foreign_key "schedules", "users"
  add_foreign_key "shipping_charges", "orders"
  add_foreign_key "taxes", "stores"
  add_foreign_key "temp_orders", "users"
  add_foreign_key "user_notifications", "users"
  add_foreign_key "users", "plans"

  create_view "search_results",  sql_definition: <<-SQL
      SELECT users.id AS searchable_id,
      'User'::text AS searchable_type,
      users.first_name AS term
     FROM users
  UNION
   SELECT users.id AS searchable_id,
      'User'::text AS searchable_type,
      users.last_name AS term
     FROM users
  UNION
   SELECT users.id AS searchable_id,
      'User'::text AS searchable_type,
      users.email AS term
     FROM users
  UNION
   SELECT menus.id AS searchable_id,
      'Menu'::text AS searchable_type,
      menus.name AS term
     FROM menus
  UNION
   SELECT menus.id AS searchable_id,
      'Menu'::text AS searchable_type,
      menus.description AS term
     FROM menus
  UNION
   SELECT menus.id AS searchable_id,
      'Menu'::text AS searchable_type,
      menus.item_number AS term
     FROM menus
  UNION
   SELECT orders.id AS searchable_id,
      'Order'::text AS searchable_type,
      orders.sku AS term
     FROM orders;
  SQL

  create_view "items_with_stocks", materialized: true,  sql_definition: <<-SQL
      SELECT menus.id AS menu_id,
      menus.name,
      menus.price,
      menus.published,
      menus.unit_size,
      menus.unit_id,
      menus.item_number,
      menus.tax,
      menus.description,
      menus.asset_id,
      inventories.quantity,
      menus.menu_category_id,
      menu_categories.name AS menu_category_name,
      menu_categories.display_order,
      ARRAY( SELECT diet_categories.name
             FROM (diet_categories
               JOIN diet_categories_menus ON (((diet_categories_menus.diet_category_id = diet_categories.id) AND (diet_categories_menus.menu_id = menus.id))))) AS diet_categories
     FROM (((menus
       JOIN menu_categories ON ((menu_categories.id = menus.menu_category_id)))
       JOIN units ON ((units.id = menus.unit_id)))
       JOIN inventories ON ((inventories.menu_id = menus.id)))
    WHERE ((inventories.quantity <> 0) AND (menu_categories.part_of_plan = true))
    GROUP BY menu_categories.id, menus.id, inventories.quantity
    ORDER BY menu_categories.display_order;
  SQL

  add_index "items_with_stocks", ["asset_id"], name: "index_items_with_stocks_on_asset_id"
  add_index "items_with_stocks", ["menu_category_id"], name: "index_items_with_stocks_on_menu_category_id"
  add_index "items_with_stocks", ["menu_id"], name: "index_items_with_stocks_on_menu_id"

end
