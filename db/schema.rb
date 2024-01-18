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

ActiveRecord::Schema[7.0].define(version: 2024_01_17_105103) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "book_masters", force: :cascade do |t|
    t.string "name"
    t.string "author"
    t.string "publisher"
    t.decimal "price"
    t.string "language"
    t.string "serial_number"
    t.bigint "topic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_book_masters_on_topic_id"
  end

  create_table "book_transactions", force: :cascade do |t|
    t.bigint "book_master_id", null: false
    t.datetime "borrow_date"
    t.datetime "return_date"
    t.bigint "borrower_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_master_id"], name: "index_book_transactions_on_book_master_id"
    t.index ["borrower_id"], name: "index_book_transactions_on_borrower_id"
  end

  create_table "borrowers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_borrowers_on_user_id"
  end

  create_table "topics", force: :cascade do |t|
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
    t.string "name"
    t.string "phone", null: false
    t.string "address"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone"], name: "index_users_on_phone", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "book_masters", "topics"
  add_foreign_key "book_transactions", "book_masters"
  add_foreign_key "book_transactions", "borrowers"
  add_foreign_key "borrowers", "users"
end
