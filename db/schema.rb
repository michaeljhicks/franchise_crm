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

ActiveRecord::Schema[8.0].define(version: 2025_11_01_032210) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.bigint "machine_id", null: false
    t.bigint "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_assignments_on_customer_id"
    t.index ["machine_id"], name: "index_assignments_on_machine_id"
  end

  create_table "contractors", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_contractors_on_user_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "business_name"
    t.string "street_address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "main_contact_name"
    t.string "main_contact_phone"
    t.string "main_contact_email"
    t.string "other_contact_name"
    t.string "other_contact_phone"
    t.date "customer_since"
    t.string "status", default: "Active"
    t.text "notes"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.datetime "scheduled_date_time"
    t.datetime "completed_date_time"
    t.integer "job_type", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.text "contractor_notes"
    t.text "internal_notes"
    t.bigint "customer_id", null: false
    t.bigint "machine_id", null: false
    t.bigint "user_id", null: false
    t.bigint "contractor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contractor_id"], name: "index_jobs_on_contractor_id"
    t.index ["customer_id"], name: "index_jobs_on_customer_id"
    t.index ["machine_id"], name: "index_jobs_on_machine_id"
    t.index ["user_id"], name: "index_jobs_on_user_id"
  end

  create_table "machines", force: :cascade do |t|
    t.string "machine_make"
    t.string "machine_model"
    t.string "machine_serial_number"
    t.string "machine_type"
    t.string "bin_make"
    t.string "bin_model"
    t.string "bin_serial_number"
    t.date "purchase_date"
    t.date "install_date"
    t.string "status"
    t.bigint "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "warranty_registered", default: false
    t.decimal "lease_rate", precision: 8, scale: 2, default: "0.0"
    t.index ["customer_id"], name: "index_machines_on_customer_id"
  end

  create_table "prospects", force: :cascade do |t|
    t.string "contact_name"
    t.string "business_name"
    t.string "business_location"
    t.string "email"
    t.string "phone"
    t.text "notes"
    t.text "business_type"
    t.text "hours"
    t.text "ice_usage"
    t.text "ice_shape"
    t.text "seating_capacity"
    t.text "special_circumstances"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_prospects_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "description"
    t.datetime "completed_at"
    t.bigint "job_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_tasks_on_job_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "franchise_location"
    t.string "owner_name"
    t.string "owner_email"
    t.string "franchise_phone"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "assignments", "customers"
  add_foreign_key "assignments", "machines"
  add_foreign_key "contractors", "users"
  add_foreign_key "customers", "users"
  add_foreign_key "jobs", "contractors"
  add_foreign_key "jobs", "customers"
  add_foreign_key "jobs", "machines"
  add_foreign_key "jobs", "users"
  add_foreign_key "machines", "customers"
  add_foreign_key "prospects", "users"
  add_foreign_key "tasks", "jobs"
end
