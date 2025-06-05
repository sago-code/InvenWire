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

ActiveRecord::Schema[8.0].define(version: 2025_05_31_000002) do
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

  create_table "inventories", force: :cascade do |t|
    t.integer "product_id"
    t.integer "warehouse_id"
    t.integer "product_stock"
    t.integer "product_state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "warehouse_id", "product_state_id"], name: "index_inventories_on_product_warehouse_state", unique: true
    t.index ["product_id"], name: "index_inventories_on_product_id"
    t.index ["product_state_id"], name: "index_inventories_on_product_state_id"
    t.index ["warehouse_id"], name: "index_inventories_on_warehouse_id"
  end

  create_table "inventory_movements", force: :cascade do |t|
    t.integer "product_id"
    t.integer "warehouse_id"
    t.integer "user_id"
    t.integer "quantity"
    t.string "movement_type"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_inventory_movements_on_product_id"
    t.index ["user_id"], name: "index_inventory_movements_on_user_id"
    t.index ["warehouse_id"], name: "index_inventory_movements_on_warehouse_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.string "name_module"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_module"], name: "index_permissions_on_name_module", unique: true
  end

  create_table "product_states", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "is_final_product"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.integer "stock", default: 0
    t.integer "warehouse_id"
    t.integer "user_id"
    t.index ["user_id"], name: "index_products_on_user_id"
    t.index ["warehouse_id"], name: "index_products_on_warehouse_id"
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

  create_table "warehouses", force: :cascade do |t|
    t.string "name"
    t.integer "location_id"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_warehouses_on_location_id", unique: true
  end

  add_foreign_key "access_user_tokens", "users"
  add_foreign_key "inventories", "product_states"
  add_foreign_key "inventories", "products"
  add_foreign_key "inventories", "warehouses"
  add_foreign_key "inventory_movements", "products"
  add_foreign_key "inventory_movements", "users"
  add_foreign_key "inventory_movements", "warehouses"
  add_foreign_key "products", "users"
  add_foreign_key "products", "warehouses"
  add_foreign_key "user_permissions", "permissions"
  add_foreign_key "user_permissions", "roles"
  add_foreign_key "user_permissions", "users"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "warehouses", "locations"
end
