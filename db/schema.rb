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

ActiveRecord::Schema[8.0].define(version: 2025_05_15_140734) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "dreams", force: :cascade do |t|
    t.text "raw_text"
    t.text "ai_summary"
    t.string "ai_keywords"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string "shopify_order_id"
    t.string "customer_name"
    t.string "status"
    t.string "tracking_number"
    t.date "ship_date"
    t.json "order_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "order_number"
    t.decimal "total_price", precision: 10, scale: 2
    t.date "delivery_date"
  end

  create_table "work_days", force: :cascade do |t|
    t.date "entry_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
  end

  create_table "work_entries", force: :cascade do |t|
    t.bigint "work_day_id", null: false
    t.text "raw_text"
    t.text "ai_summary"
    t.string "ai_keywords"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["work_day_id"], name: "index_work_entries_on_work_day_id"
  end

  add_foreign_key "work_entries", "work_days"
end
