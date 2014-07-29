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

ActiveRecord::Schema.define(version: 20140729083317) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.string   "type"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
    t.integer  "user_id"
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

  create_table "carriers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_carriers", force: true do |t|
    t.integer  "customer_id"
    t.integer  "carrier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_destinations", force: true do |t|
    t.integer  "customer_id"
    t.integer  "destination_id"
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

  create_table "customer_stopovers", force: true do |t|
    t.integer  "customer_id"
    t.integer  "stopover_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
    t.integer  "user_id"
    t.integer  "lead_id"
    t.integer  "assigned_to"
    t.integer  "reports_to"
    t.string   "first_name",      limit: 64,  default: "",    null: false
    t.string   "last_name",       limit: 64,  default: "",    null: false
    t.string   "title",           limit: 64
    t.string   "source",          limit: 32
    t.string   "email",           limit: 64
    t.string   "alt_email",       limit: 64
    t.string   "phone",           limit: 32
    t.string   "mobile",          limit: 32
    t.string   "fax",             limit: 32
    t.string   "blog",            limit: 128
    t.string   "linkedin",        limit: 128
    t.string   "facebook",        limit: 128
    t.string   "twitter",         limit: 128
    t.date     "born_on"
    t.boolean  "do_not_call",                 default: false, null: false
    t.datetime "deleted_at"
    t.string   "background_info"
    t.string   "skype",           limit: 128
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "issue_date"
    t.date     "expiry_date"
    t.string   "place_of_issue"
    t.string   "passport_num"
    t.string   "insurance"
    t.string   "gender"
  end

  add_index "customers", ["assigned_to"], name: "index_customers_on_assigned_to", using: :btree

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
    t.text     "destinations"
    t.text     "stopovers"
    t.text     "carriers"
  end

  add_index "enquiries", ["assigned_to"], name: "index_opportunities_on_assigned_to", using: :btree

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

end
