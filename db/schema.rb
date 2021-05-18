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

ActiveRecord::Schema.define(version: 2021_05_18_115824) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "properties", force: :cascade do |t|
    t.string "name"
    t.string "approval_status", limit: 64, default: "ON_HOLD"
    t.boolean "active", default: true
    t.string "availability_status", limit: 64, default: "ON_HOLD"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "property_id"
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_properties_on_created_by_id"
    t.index ["property_id"], name: "index_properties_on_property_id"
    t.index ["updated_by_id"], name: "index_properties_on_updated_by_id"
  end

  create_table "user_properties", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_tokens", force: :cascade do |t|
    t.bigint "users_id"
    t.bigint "user_id"
    t.string "token", null: false
    t.boolean "active"
    t.datetime "expires_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_tokens_on_user_id"
    t.index ["users_id"], name: "index_user_tokens_on_users_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "role", limit: 64
    t.string "status", limit: 64, default: "ACTIVE"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["user_id"], name: "index_users_on_user_id"
  end

  add_foreign_key "properties", "properties"
  add_foreign_key "properties", "users", column: "created_by_id"
  add_foreign_key "properties", "users", column: "updated_by_id"
  add_foreign_key "user_tokens", "users"
  add_foreign_key "user_tokens", "users", column: "users_id"
  add_foreign_key "users", "users"
end
