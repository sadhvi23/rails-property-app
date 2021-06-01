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

ActiveRecord::Schema.define(version: 2021_05_31_122234) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "properties", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "owner_id"
    t.boolean "is_approved", default: false
    t.boolean "is_available", default: false
    t.boolean "is_active", default: false
    t.index ["owner_id"], name: "index_properties_on_owner_id"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name", default: ""
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "role_id"
    t.index ["role_id"], name: "index_roles_on_role_id"
  end

  create_table "user_tokens", id: :serial, force: :cascade do |t|
    t.bigint "users_id"
    t.integer "user_id"
    t.string "token", null: false
    t.boolean "active"
    t.datetime "expires_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_tokens_on_user_id"
    t.index ["users_id"], name: "index_user_tokens_on_users_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "role_id"
    t.boolean "is_active"
    t.bigint "user_id"
    t.text "salt"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["user_id"], name: "index_users_on_user_id"
  end

  add_foreign_key "properties", "users", column: "owner_id"
  add_foreign_key "roles", "roles"
  add_foreign_key "user_tokens", "users"
  add_foreign_key "user_tokens", "users", column: "users_id"
  add_foreign_key "users", "roles"
  add_foreign_key "users", "users"
end
