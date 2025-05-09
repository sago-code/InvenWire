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

ActiveRecord::Schema[8.0].define(version: 2025_05_09_170237) do
  create_table "access_user_tokens", force: :cascade do |t|
    t.string "token"
    t.integer "user_id"
    t.datetime "expiration_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "expired"
    t.index ["expiration_date"], name: "index_access_user_tokens_on_expiration_date"
    t.index ["token"], name: "index_access_user_tokens_on_token", unique: true
    t.index ["user_id", "token"], name: "index_access_user_tokens_on_user_id_and_token", unique: true
    t.index ["user_id"], name: "index_access_user_tokens_on_user_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "name_module"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_module"], name: "index_permissions_on_name_module", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "user_permissions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.integer "permission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_user_permissions_on_permission_id"
    t.index ["role_id"], name: "index_user_permissions_on_role_id"
    t.index ["user_id", "permission_id", "role_id"], name: "idx_on_user_id_permission_id_role_id_9906cc4ac1", unique: true
    t.index ["user_id"], name: "index_user_permissions_on_user_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_user_roles_on_user_id_and_role_id", unique: true
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "document"
    t.string "phone"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document"], name: "index_users_on_document", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone"], name: "index_users_on_phone", unique: true
  end

  add_foreign_key "access_user_tokens", "users"
  add_foreign_key "user_permissions", "permissions"
  add_foreign_key "user_permissions", "roles"
  add_foreign_key "user_permissions", "users"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
end
