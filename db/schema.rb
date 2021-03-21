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

ActiveRecord::Schema.define(version: 2021_03_13_095056) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "baskets", force: :cascade do |t|
    t.string "name", null: false
    t.integer "price", null: false
    t.string "process"
    t.integer "num", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "in_basket_at", null: false
    t.index ["user_id"], name: "index_baskets_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.binary "image"
    t.string "name", null: false
    t.string "category", null: false
    t.string "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string "name", null: false
    t.integer "price", null: false
    t.string "process"
    t.integer "num", null: false
    t.integer "status", default: 1, null: false
    t.date "order_date", null: false
    t.datetime "order_time", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "order_date_details", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "processings", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_processings_on_item_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.integer "price", null: false
    t.text "process"
    t.datetime "seles_date", null: false
    t.integer "stock", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "name_kana", null: false
    t.string "tellnumber", null: false
    t.string "email", null: false
    t.boolean "employee", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "baskets", "users"
  add_foreign_key "orders", "users"
  add_foreign_key "processings", "items"
end
