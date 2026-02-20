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

ActiveRecord::Schema[8.0].define(version: 2025_02_19_110000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "companies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "onboarding_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id", null: false
    t.bigint "current_step_id"
    t.index ["company_id"], name: "index_onboarding_processes_on_company_id"
    t.index ["current_step_id"], name: "index_onboarding_processes_on_current_step_id"
  end

  create_table "onboarding_step_submissions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id", null: false
    t.bigint "step_id", null: false
    t.string "status", null: false
    t.jsonb "values", default: {}
    t.datetime "completed_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "step_id"], name: "index_onboarding_step_submissions_on_company_id_and_step_id", unique: true
    t.index ["company_id"], name: "index_onboarding_step_submissions_on_company_id"
    t.index ["step_id"], name: "index_onboarding_step_submissions_on_step_id"
  end

  create_table "onboarding_steps", force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.integer "sort_order", null: false
    t.string "category"
    t.boolean "is_active", default: false, null: false
    t.boolean "is_mandatory", default: true, null: false
    t.bigint "dependency_step_id"
    t.string "required_sync_entity"
    t.index ["dependency_step_id"], name: "index_onboarding_steps_on_dependency_step_id"
    t.index ["slug"], name: "index_onboarding_steps_on_slug", unique: true
  end

  create_table "products", primary_key: "sku_id", id: :string, force: :cascade do |t|
    t.uuid "company_id", null: false
    t.uuid "vendor_id", null: false
    t.string "name", null: false
    t.integer "lead_time_days"
    t.integer "days_of_stock"
    t.integer "forecasting_days"
    t.index ["company_id"], name: "index_products_on_company_id"
    t.index ["vendor_id"], name: "index_products_on_vendor_id"
  end

  create_table "sales_history", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "product_sku", null: false
    t.date "sale_date", null: false
    t.integer "quantity", null: false
    t.index ["product_sku", "sale_date"], name: "index_sales_history_on_product_sku_and_sale_date"
  end

  create_table "sync_status", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id", null: false
    t.string "entity_type", null: false
    t.integer "total_count", default: 0
    t.integer "synced_count", default: 0
    t.boolean "is_finished", default: false, null: false
    t.index ["company_id", "entity_type"], name: "index_sync_status_on_company_id_and_entity_type", unique: true
    t.index ["company_id"], name: "index_sync_status_on_company_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id", null: false
    t.string "email", null: false
    t.string "role", null: false
    t.string "password_digest"
    t.index ["company_id", "email"], name: "index_users_on_company_id_and_email", unique: true
    t.index ["company_id"], name: "index_users_on_company_id"
  end

  create_table "vendors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id", null: false
    t.string "name", null: false
    t.jsonb "contact_info", default: {}
    t.index ["company_id"], name: "index_vendors_on_company_id"
  end

  create_table "warehouses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id", null: false
    t.string "name", null: false
    t.text "address"
    t.index ["company_id"], name: "index_warehouses_on_company_id"
  end

  add_foreign_key "onboarding_processes", "companies"
  add_foreign_key "onboarding_processes", "onboarding_steps", column: "current_step_id"
  add_foreign_key "onboarding_step_submissions", "companies"
  add_foreign_key "onboarding_step_submissions", "onboarding_steps", column: "step_id"
  add_foreign_key "onboarding_steps", "onboarding_steps", column: "dependency_step_id"
  add_foreign_key "products", "companies"
  add_foreign_key "products", "vendors"
  add_foreign_key "sales_history", "products", column: "product_sku", primary_key: "sku_id"
  add_foreign_key "sync_status", "companies"
  add_foreign_key "users", "companies"
  add_foreign_key "vendors", "companies"
  add_foreign_key "warehouses", "companies"
end
