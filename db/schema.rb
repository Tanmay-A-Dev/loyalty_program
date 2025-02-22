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

ActiveRecord::Schema[7.1].define(version: 2024_04_16_113403) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "rewards", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.datetime "claimed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_rewards_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "amount", precision: 10, scale: 2
    t.boolean "foreign_transaction", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "points", default: 0
    t.integer "tier", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "birthday"
    t.datetime "first_transaction_date"
    t.integer "monthly_points"
    t.date "points_expiration"
  end

  add_foreign_key "rewards", "users"
  add_foreign_key "transactions", "users"
end
