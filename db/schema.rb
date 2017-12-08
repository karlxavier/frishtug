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

ActiveRecord::Schema.define(version: 20171206065323) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "add_ons", force: :cascade do |t|
    t.string "name"
    t.bigint "menu_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_category_id"], name: "index_add_ons_on_menu_category_id"
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
    t.float "latitude"
    t.float "longitude"
    t.integer "status"
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

  create_table "inventories", force: :cascade do |t|
    t.bigint "menu_id"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "inventory_id"
    t.index ["inventory_id"], name: "index_inventories_on_inventory_id"
    t.index ["menu_id"], name: "index_inventories_on_menu_id"
  end

  create_table "inventory_transactions", force: :cascade do |t|
    t.bigint "inventory_id"
    t.integer "quantity_sold"
    t.datetime "transaction_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_id"], name: "index_inventory_transactions_on_inventory_id"
  end

  create_table "menu_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menus", force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 8, scale: 2
    t.bigint "unit_id"
    t.bigint "menu_category_id"
    t.bigint "diet_category_id"
    t.datetime "published_at"
    t.boolean "published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.integer "unit_size"
    t.string "item_number"
    t.boolean "tax", default: false
    t.text "description"
    t.index ["diet_category_id"], name: "index_menus_on_diet_category_id"
    t.index ["menu_category_id"], name: "index_menus_on_menu_category_id"
    t.index ["name"], name: "index_menus_on_name", unique: true
    t.index ["unit_id"], name: "index_menus_on_unit_id"
  end

  create_table "menus_orders", force: :cascade do |t|
    t.bigint "menu_id"
    t.bigint "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_id"], name: "index_menus_orders_on_menu_id"
    t.index ["order_id"], name: "index_menus_orders_on_order_id"
  end

  create_table "menus_temp_orders", force: :cascade do |t|
    t.bigint "menu_id"
    t.bigint "temp_order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_id"], name: "index_menus_temp_orders_on_menu_id"
    t.index ["temp_order_id"], name: "index_menus_temp_orders_on_temp_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "placed_on"
    t.datetime "eta"
    t.datetime "delivered_at"
    t.integer "status"
    t.string "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "order_date"
    t.index ["order_date"], name: "index_orders_on_order_date"
    t.index ["user_id"], name: "index_orders_on_user_id"
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
    t.index ["stripe_plan_id"], name: "index_plans_on_stripe_plan_id"
  end

  create_table "referrers", force: :cascade do |t|
    t.bigint "user_id"
    t.string "group_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_referrers_on_user_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "option"
    t.datetime "start_date"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_schedules_on_user_id"
  end

  create_table "stores", force: :cascade do |t|
    t.integer "_id"
    t.string "_code"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "home_page_images", default: [], array: true
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
  add_foreign_key "add_ons_menus", "add_ons"
  add_foreign_key "add_ons_menus", "menus"
  add_foreign_key "allowed_zip_codes", "stores"
  add_foreign_key "candidates", "referrers"
  add_foreign_key "candidates", "users"
  add_foreign_key "checkings", "users"
  add_foreign_key "comments", "users"
  add_foreign_key "contact_numbers", "users"
  add_foreign_key "credit_cards", "users"
  add_foreign_key "inventories", "menus"
  add_foreign_key "inventory_transactions", "inventories"
  add_foreign_key "menus", "diet_categories"
  add_foreign_key "menus", "menu_categories"
  add_foreign_key "menus", "units"
  add_foreign_key "menus_orders", "menus"
  add_foreign_key "menus_orders", "orders"
  add_foreign_key "menus_temp_orders", "menus"
  add_foreign_key "menus_temp_orders", "temp_orders"
  add_foreign_key "orders", "users"
  add_foreign_key "referrers", "users"
  add_foreign_key "schedules", "users"
  add_foreign_key "temp_orders", "users"
  add_foreign_key "users", "plans"
end
