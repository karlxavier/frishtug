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

ActiveRecord::Schema.define(version: 20171009082054) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "add_ons", force: :cascade do |t|
    t.string "name"
    t.bigint "menu_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_category_id"], name: "index_add_ons_on_menu_category_id"
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

  create_table "diet_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["diet_category_id"], name: "index_menus_on_diet_category_id"
    t.index ["menu_category_id"], name: "index_menus_on_menu_category_id"
    t.index ["unit_id"], name: "index_menus_on_unit_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price", precision: 8, scale: 2
    t.integer "shipping"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "shipping_fee", precision: 8, scale: 2
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["first_name"], name: "index_users_on_first_name"
    t.index ["last_name"], name: "index_users_on_last_name"
    t.index ["plan_id"], name: "index_users_on_plan_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "add_ons", "menu_categories"
  add_foreign_key "menus", "diet_categories"
  add_foreign_key "menus", "menu_categories"
  add_foreign_key "menus", "units"
  add_foreign_key "users", "plans"
end
