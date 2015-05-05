# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150505071929) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "type",        limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
    t.integer  "user_id"
    t.string   "user_email",  limit: 255
    t.integer  "enquiry_id"
  end

  create_table "addresses", force: :cascade do |t|
    t.string   "street1",          limit: 255
    t.string   "street2",          limit: 255
    t.string   "city",             limit: 64
    t.string   "state",            limit: 64
    t.string   "zipcode",          limit: 16
    t.string   "country",          limit: 64
    t.string   "full_address",     limit: 255
    t.string   "address_type",     limit: 16
    t.integer  "addressable_id"
    t.string   "addressable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "addresses", ["addressable_id", "addressable_type"], name: "index_addresses_on_addressable_id_and_addressable_type", using: :btree

  create_table "bookings", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "enquiry_id"
    t.integer  "user_id"
    t.decimal  "amount",                  precision: 12, scale: 2
    t.decimal  "deposit",                 precision: 12, scale: 2
    t.string   "name",        limit: 255
    t.string   "status",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "xpayments"
    t.string   "xero_id",     limit: 255
    t.text     "xdeposits"
    t.integer  "agent_id"
  end

  create_table "carriers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carriers_enquiries", id: false, force: :cascade do |t|
    t.integer "enquiry_id"
    t.integer "carrier_id"
  end

  create_table "currencies", force: :cascade do |t|
    t.string   "code",       limit: 255
    t.string   "currency",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_enquiries", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "enquiry_id"
    t.string   "role",        limit: 32
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "lead_id"
    t.integer  "assigned_to"
    t.integer  "reports_to"
    t.string   "first_name",           limit: 64,  default: "",    null: false
    t.string   "last_name",            limit: 64,  default: "",    null: false
    t.string   "title",                limit: 64
    t.string   "source",               limit: 32
    t.string   "email",                limit: 64
    t.string   "alt_email",            limit: 64
    t.string   "phone",                limit: 32
    t.string   "mobile",               limit: 32
    t.string   "fax",                  limit: 32
    t.string   "blog",                 limit: 128
    t.string   "linkedin",             limit: 128
    t.string   "facebook",             limit: 128
    t.string   "twitter",              limit: 128
    t.date     "born_on"
    t.boolean  "do_not_call",                      default: false, null: false
    t.datetime "deleted_at"
    t.string   "background_info",      limit: 255
    t.string   "skype",                limit: 128
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "issue_date"
    t.date     "expiry_date"
    t.string   "place_of_issue",       limit: 255
    t.string   "passport_num",         limit: 255
    t.string   "insurance",            limit: 255
    t.string   "gender",               limit: 255
    t.string   "emailID",              limit: 255
    t.string   "xero_id",              limit: 255
    t.string   "cust_sup",             limit: 255
    t.string   "supplier_name",        limit: 255
    t.integer  "currency_id"
    t.integer  "num_days_payment_due"
    t.string   "after_hours_phone",    limit: 32
  end

  add_index "customers", ["assigned_to"], name: "index_customers_on_assigned_to", using: :btree
  add_index "customers", ["emailID"], name: "index_customers_on_emailID", using: :btree

  create_table "customers_activities", force: :cascade do |t|
    t.integer  "activity_id"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "destinations", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "destinations_enquiries", id: false, force: :cascade do |t|
    t.integer "enquiry_id"
    t.integer "destination_id"
  end

  create_table "email_templates", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "from_email",         limit: 255
    t.string   "from_name",          limit: 255
    t.string   "subject",            limit: 255
    t.string   "body",               limit: 255
    t.boolean  "copy_assigned_user"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enquiries", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "assigned_to"
    t.string   "name",             limit: 64,                           default: "",       null: false
    t.string   "access",           limit: 8,                            default: "Public"
    t.string   "source",           limit: 32
    t.string   "stage",            limit: 32
    t.string   "probability",      limit: 255
    t.decimal  "amount",                       precision: 12, scale: 2
    t.decimal  "discount",                     precision: 12, scale: 2
    t.date     "closes_on"
    t.datetime "deleted_at"
    t.string   "background_info",  limit: 255
    t.text     "subscribed_users"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "duration",         limit: 255
    t.date     "est_date"
    t.string   "num_people",       limit: 255
    t.integer  "percent"
    t.date     "fin_date"
    t.string   "standard",         limit: 255
    t.boolean  "insurance"
    t.date     "reminder"
    t.string   "xero_id",          limit: 255
    t.text     "xpayments"
    t.integer  "agent_id"
  end

  add_index "enquiries", ["assigned_to"], name: "index_opportunities_on_assigned_to", using: :btree

  create_table "enquiries_activities", force: :cascade do |t|
    t.integer  "activity_id"
    t.integer  "enquiry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enquiries_stopovers", id: false, force: :cascade do |t|
    t.integer "enquiry_id"
    t.integer "stopover_id"
  end

  create_table "exchange_rates", force: :cascade do |t|
    t.decimal  "exchange_rate",             precision: 12, scale: 5
    t.string   "currency_code", limit: 255
    t.integer  "setting_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer  "booking_id"
    t.string   "status",              limit: 255
    t.datetime "invoice_date"
    t.datetime "deposit_due"
    t.datetime "final_payment_due"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "deposit",                         precision: 12, scale: 2
    t.string   "depositPayUrl",       limit: 255
    t.text     "ccPaymentsAmount"
    t.text     "ccPaymentsDate"
    t.integer  "supplier_invoice_id"
    t.integer  "customer_invoice_id"
    t.string   "currency",            limit: 255
    t.string   "xero_id",             limit: 255
    t.text     "xdeposits"
    t.text     "xpayments"
    t.integer  "supplier_id"
    t.integer  "currency_id"
    t.decimal  "exchange_amount",                 precision: 12, scale: 2
    t.decimal  "exchange_rate",                   precision: 12, scale: 2
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "invoice_id"
    t.decimal  "item_price",              precision: 12, scale: 2
    t.decimal  "total",                   precision: 12, scale: 2
    t.string   "description", limit: 255
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deposit"
  end

  create_table "payments", force: :cascade do |t|
    t.decimal  "amount",                  precision: 12, scale: 5
    t.string   "payment_ref", limit: 255
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "reference"
    t.date     "date"
  end

  create_table "settings", force: :cascade do |t|
    t.string   "company_name",         limit: 255
    t.string   "pxpay_user_id",        limit: 255
    t.string   "pxpay_key",            limit: 255
    t.boolean  "use_xero"
    t.string   "xero_consumer_key",    limit: 255
    t.string   "xero_consumer_secret", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id"
    t.string   "payment_gateway",      limit: 255
  end

  create_table "stopovers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tours", force: :cascade do |t|
    t.string   "tourName",    limit: 255
    t.string   "destination", limit: 255
    t.string   "country",     limit: 255
    t.decimal  "tourPrice"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image",       limit: 255
  end

  create_table "triggers", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.integer  "num_days"
    t.integer  "setting_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "email_template_id"
  end

  add_index "triggers", ["email_template_id"], name: "index_triggers_on_email_template_id", using: :btree
  add_index "triggers", ["name"], name: "index_triggers_on_name", using: :btree
  add_index "triggers", ["setting_id"], name: "index_triggers_on_setting_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "email",                  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest",        limit: 255
    t.string   "remember_token",         limit: 255
    t.boolean  "remember_me"
    t.boolean  "admin",                              default: false
    t.string   "password_reset_token",   limit: 255
    t.datetime "password_reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "users_activities", force: :cascade do |t|
    t.integer  "activity_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      limit: 255, null: false
    t.integer  "item_id",                    null: false
    t.string   "event",          limit: 255, null: false
    t.string   "whodunnit",      limit: 255
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.text     "customer_names"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "x_invoices", force: :cascade do |t|
    t.decimal  "amount_due",                 precision: 12, scale: 5
    t.decimal  "amount_paid",                precision: 12, scale: 5
    t.decimal  "total",                      precision: 12, scale: 5
    t.string   "currency_code",  limit: 255
    t.string   "currency_rate",  limit: 255
    t.date     "date"
    t.string   "invoice_ref",    limit: 255
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_sync"
    t.string   "invoice_number", limit: 255
    t.date     "due_date"
    t.string   "status",         limit: 255
  end

end
