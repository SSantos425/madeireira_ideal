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

ActiveRecord::Schema[7.0].define(version: 2024_03_20_144929) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cart_list_orderables", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "cart_list_id", null: false
    t.bigint "client_id", null: false
    t.float "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_list_id"], name: "index_cart_list_orderables_on_cart_list_id"
    t.index ["client_id"], name: "index_cart_list_orderables_on_client_id"
    t.index ["product_id"], name: "index_cart_list_orderables_on_product_id"
  end

  create_table "cart_lists", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.float "balance"
    t.integer "payment_method"
    t.date "date"
    t.float "discount"
    t.float "additon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_cart_lists_on_client_id"
  end

  create_table "carts", force: :cascade do |t|
    t.float "balance"
    t.float "discount"
    t.float "addition"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cash_register_lists", force: :cascade do |t|
    t.bigint "cash_register_id", null: false
    t.date "date"
    t.float "balance"
    t.string "note"
    t.integer "cash_register_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cash_register_id"], name: "index_cash_register_lists_on_cash_register_id"
  end

  create_table "cash_registers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.float "balance"
    t.float "cash_replenishment"
    t.date "date"
    t.integer "cash_register_status"
    t.float "open_value"
    t.float "close_value"
    t.float "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_cash_registers_on_user_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "cpf"
    t.string "customer_type"
    t.integer "cep"
    t.string "address"
    t.string "district"
    t.string "city"
    t.string "state"
    t.string "cnpj"
    t.string "state_registration"
    t.string "municipal_registration"
    t.string "business_sector"
    t.integer "ibge_code"
    t.text "notes"
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventories", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.float "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_inventories_on_product_id"
  end

  create_table "orderables", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "cart_id", null: false
    t.bigint "client_id", null: false
    t.float "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_orderables_on_cart_id"
    t.index ["client_id"], name: "index_orderables_on_client_id"
    t.index ["product_id"], name: "index_orderables_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "unity"
    t.float "sale_price"
    t.float "purchase_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "purchase_lists", force: :cascade do |t|
    t.bigint "purchase_id", null: false
    t.bigint "product_id", null: false
    t.float "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_purchase_lists_on_product_id"
    t.index ["purchase_id"], name: "index_purchase_lists_on_purchase_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.bigint "supplier_id", null: false
    t.integer "nota_number"
    t.integer "serie"
    t.date "issue_date"
    t.date "receipt_date"
    t.float "total_nota"
    t.float "total_products"
    t.float "discount"
    t.float "additon"
    t.float "tax"
    t.float "shipping"
    t.integer "purchase_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supplier_id"], name: "index_purchases_on_supplier_id"
  end

  create_table "sales", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.float "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_sales_on_product_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.integer "cep"
    t.string "address"
    t.string "number"
    t.string "complement"
    t.string "district"
    t.string "city"
    t.string "state"
    t.string "phone"
    t.string "cnpj"
    t.string "state_registration"
    t.string "corporate_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "cart_list_orderables", "cart_lists"
  add_foreign_key "cart_list_orderables", "clients"
  add_foreign_key "cart_list_orderables", "products"
  add_foreign_key "cart_lists", "clients"
  add_foreign_key "cash_register_lists", "cash_registers"
  add_foreign_key "cash_registers", "users"
  add_foreign_key "inventories", "products"
  add_foreign_key "orderables", "carts"
  add_foreign_key "orderables", "clients"
  add_foreign_key "orderables", "products"
  add_foreign_key "purchase_lists", "products"
  add_foreign_key "purchase_lists", "purchases"
  add_foreign_key "purchases", "suppliers"
  add_foreign_key "sales", "products"
end
