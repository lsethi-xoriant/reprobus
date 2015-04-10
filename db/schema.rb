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

ActiveRecord::Schema.define(version: 20150409223355) do

  create_table "activities", force: true do |t|
    t.string   "type"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
    t.integer  "user_id"
    t.string   "user_email"
    t.integer  "enquiry_id"
  end

  create_table "addresses", force: true do |t|
    t.string   "street1"
    t.string   "street2"
    t.string   "city",             limit: 64
    t.string   "state",            limit: 64
    t.string   "zipcode",          limit: 16
    t.string   "country",          limit: 64
    t.string   "full_address"
    t.string   "address_type",     limit: 16
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "addresses", ["addressable_id", "addressable_type"], name: "index_addresses_on_addressable_id_and_addressable_type", using: :btree

  create_table "bookings", force: true do |t|
    t.integer  "customer_id"
    t.integer  "enquiry_id"
    t.integer  "user_id"
    t.decimal  "amount",      precision: 12, scale: 2
    t.decimal  "deposit",     precision: 12, scale: 2
    t.string   "name"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "xpayments"
    t.string   "xero_id"
    t.text     "xdeposits"
    t.integer  "agent_id"
  end

  create_table "carriers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carriers_enquiries", id: false, force: true do |t|
    t.integer "enquiry_id"
    t.integer "carrier_id"
  end

  create_table "currencies", force: true do |t|
    t.string   "code"
    t.string   "currency"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_enquiries", force: true do |t|
    t.integer  "customer_id"
    t.integer  "enquiry_id"
    t.string   "role",        limit: 32
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
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
    t.string   "background_info"
    t.string   "skype",                limit: 128
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "issue_date"
    t.date     "expiry_date"
    t.string   "place_of_issue"
    t.string   "passport_num"
    t.string   "insurance"
    t.string   "gender"
    t.string   "emailID"
    t.string   "xero_id"
    t.string   "cust_sup"
    t.string   "supplier_name"
    t.integer  "currency_id"
    t.integer  "num_days_payment_due"
    t.string   "after_hours_phone",    limit: 32
  end

  add_index "customers", ["assigned_to"], name: "index_customers_on_assigned_to", using: :btree
  add_index "customers", ["emailID"], name: "index_customers_on_emailID", using: :btree

  create_table "customers_activities", force: true do |t|
    t.integer  "activity_id"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "destinations", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "destinations_enquiries", id: false, force: true do |t|
    t.integer "enquiry_id"
    t.integer "destination_id"
  end

  create_table "enquiries", force: true do |t|
    t.integer  "user_id"
    t.integer  "assigned_to"
    t.string   "name",             limit: 64,                          default: "",       null: false
    t.string   "access",           limit: 8,                           default: "Public"
    t.string   "source",           limit: 32
    t.string   "stage",            limit: 32
    t.string   "probability"
    t.decimal  "amount",                      precision: 12, scale: 2
    t.decimal  "discount",                    precision: 12, scale: 2
    t.date     "closes_on"
    t.datetime "deleted_at"
    t.string   "background_info"
    t.text     "subscribed_users"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "duration"
    t.date     "est_date"
    t.string   "num_people"
    t.integer  "percent"
    t.date     "fin_date"
    t.string   "standard"
    t.boolean  "insurance"
    t.date     "reminder"
    t.string   "xero_id"
    t.text     "xpayments"
    t.integer  "agent_id"
  end

  add_index "enquiries", ["assigned_to"], name: "index_opportunities_on_assigned_to", using: :btree

  create_table "enquiries_activities", force: true do |t|
    t.integer  "activity_id"
    t.integer  "enquiry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enquiries_stopovers", id: false, force: true do |t|
    t.integer "enquiry_id"
    t.integer "stopover_id"
  end

  create_table "exchange_rates", force: true do |t|
    t.decimal  "exchange_rate", precision: 12, scale: 5
    t.string   "currency_code"
    t.integer  "setting_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", force: true do |t|
    t.integer  "booking_id"
    t.string   "status"
    t.datetime "invoice_date"
    t.datetime "deposit_due"
    t.datetime "final_payment_due"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "deposit",             precision: 12, scale: 2
    t.string   "depositPayUrl"
    t.text     "ccPaymentsAmount"
    t.text     "ccPaymentsDate"
    t.integer  "supplier_invoice_id"
    t.integer  "customer_invoice_id"
    t.string   "currency"
    t.string   "xero_id"
    t.text     "xdeposits"
    t.text     "xpayments"
    t.integer  "supplier_id"
    t.integer  "currency_id"
    t.decimal  "exchange_amount",     precision: 12, scale: 2
    t.decimal  "exchange_rate",       precision: 12, scale: 2
  end

  create_table "line_items", force: true do |t|
    t.integer  "invoice_id"
    t.decimal  "item_price",  precision: 12, scale: 2
    t.decimal  "total",       precision: 12, scale: 2
    t.string   "description"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deposit"
  end

  create_table "payments", force: true do |t|
    t.decimal  "amount",      precision: 12, scale: 5
    t.string   "payment_ref"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "reference"
    t.date     "date"
  end

  create_table "settings", force: true do |t|
    t.string   "company_name"
    t.string   "pxpay_user_id"
    t.string   "pxpay_key"
    t.boolean  "use_xero"
    t.string   "xero_consumer_key"
    t.string   "xero_consumer_secret"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id"
    t.string   "payment_gateway"
  end

  create_table "stopovers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tours", force: true do |t|
    t.string   "tourName"
    t.string   "destination"
    t.string   "country"
    t.decimal  "tourPrice"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "remember_me"
    t.boolean  "admin",                  default: false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "users_activities", force: true do |t|
    t.integer  "activity_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.text     "customer_names"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "x_invoices", force: true do |t|
    t.decimal  "amount_due",     precision: 12, scale: 5
    t.decimal  "amount_paid",    precision: 12, scale: 5
    t.decimal  "total",          precision: 12, scale: 5
    t.string   "currency_code"
    t.string   "currency_rate"
    t.date     "date"
    t.string   "invoice_ref"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_sync"
    t.string   "invoice_number"
    t.date     "due_date"
    t.string   "status"
  end

end
