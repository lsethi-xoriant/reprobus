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

ActiveRecord::Schema.define(version: 20160208082320) do

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
    t.text     "street1"
    t.text     "street2"
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

  create_table "booking_histories", force: :cascade do |t|
    t.datetime "emailed_at"
    t.string   "emailed_to"
    t.integer  "document_type"
    t.string   "attachment"
    t.integer  "itinerary_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "enquiry_id"
    t.integer  "user_id"
    t.decimal  "amount",                  precision: 12, scale: 2, default: 0.0
    t.decimal  "deposit",                 precision: 12, scale: 2, default: 0.0
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

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "visa_details"
    t.text     "warnings"
    t.text     "vaccinations"
  end

  create_table "currencies", force: :cascade do |t|
    t.string   "code",       limit: 255
    t.string   "currency",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "lead_id"
    t.integer  "assigned_to"
    t.integer  "reports_to"
    t.string   "first_name",                   limit: 64,  default: "",    null: false
    t.string   "last_name",                    limit: 64,  default: "",    null: false
    t.string   "title",                        limit: 64
    t.string   "source",                       limit: 32
    t.string   "email",                        limit: 64
    t.string   "alt_email",                    limit: 64
    t.string   "phone",                        limit: 255
    t.string   "alt_phone",                    limit: 32
    t.string   "fax",                          limit: 32
    t.string   "blog",                         limit: 128
    t.string   "linkedin",                     limit: 128
    t.string   "facebook",                     limit: 128
    t.string   "twitter",                      limit: 128
    t.date     "born_on"
    t.boolean  "do_not_call",                              default: false, null: false
    t.datetime "deleted_at"
    t.string   "background_info",              limit: 255
    t.string   "skype",                        limit: 128
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "issue_date"
    t.date     "expiry_date"
    t.string   "place_of_issue",               limit: 255
    t.string   "passport_num",                 limit: 255
    t.string   "insurance",                    limit: 255
    t.string   "gender",                       limit: 255
    t.string   "emailID",                      limit: 255
    t.string   "xero_id",                      limit: 255
    t.string   "cust_sup",                     limit: 255
    t.string   "supplier_name",                limit: 255
    t.integer  "currency_id"
    t.integer  "num_days_payment_due"
    t.string   "after_hours_phone",            limit: 255
    t.integer  "company_logo_id"
    t.integer  "agent_commision_percentage",               default: 0
    t.integer  "setting_id"
    t.text     "quote_introduction"
    t.text     "confirmed_introduction"
    t.string   "public_edit_token"
    t.date     "public_edit_token_expiry"
    t.text     "frequent_flyer_details"
    t.string   "emergency_contact"
    t.string   "emergency_contact_phone"
    t.text     "dietary_requirements"
    t.text     "medical_information"
    t.string   "nationality"
    t.integer  "who_requested_update_user_id"
    t.boolean  "dummy_supplier",                           default: false
  end

  add_index "customers", ["assigned_to"], name: "index_customers_on_assigned_to", using: :btree
  add_index "customers", ["emailID"], name: "index_customers_on_emailID", using: :btree

  create_table "customers_activities", force: :cascade do |t|
    t.integer  "activity_id"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers_enquiries", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "enquiry_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customers_enquiries", ["customer_id"], name: "index_customers_enquiries_on_customer_id", using: :btree
  add_index "customers_enquiries", ["enquiry_id"], name: "index_customers_enquiries_on_enquiry_id", using: :btree

  create_table "customers_itineraries", id: false, force: :cascade do |t|
    t.integer "customer_id"
    t.integer "itinerary_id"
  end

  create_table "customers_products", id: false, force: :cascade do |t|
    t.integer "customer_id"
    t.integer "product_id"
  end

  add_index "customers_products", ["customer_id"], name: "index_customers_products_on_customer_id", using: :btree
  add_index "customers_products", ["product_id"], name: "index_customers_products_on_product_id", using: :btree

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
    t.string   "name",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "country_id"
    t.integer  "default_image_id"
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
    t.text     "body"
    t.boolean  "copy_assigned_user"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enquiries", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "assigned_to"
    t.string   "name",               limit: 64,                           default: "",       null: false
    t.string   "access",             limit: 8,                            default: "Public"
    t.string   "source",             limit: 32
    t.string   "stage",              limit: 32
    t.string   "probability",        limit: 255
    t.decimal  "amount",                         precision: 12, scale: 2, default: 0.0,      null: false
    t.decimal  "discount",                       precision: 12, scale: 2, default: 0.0,      null: false
    t.date     "closes_on"
    t.datetime "deleted_at"
    t.string   "background_info",    limit: 255
    t.text     "subscribed_users"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "duration",           limit: 255
    t.date     "est_date"
    t.string   "num_people",         limit: 255
    t.integer  "percent"
    t.date     "fin_date"
    t.string   "standard",           limit: 255
    t.boolean  "insurance"
    t.date     "reminder"
    t.string   "xero_id",            limit: 255
    t.text     "xpayments"
    t.integer  "agent_id"
    t.integer  "lead_customer_id"
    t.string   "lead_customer_name"
    t.text     "campaign"
    t.date     "dismissed_until"
    t.integer  "country_id"
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

  create_table "image_holders", force: :cascade do |t|
    t.string   "image_local"
    t.string   "image_remote_url"
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
    t.decimal  "deposit",                         precision: 12, scale: 2, default: 0.0
    t.string   "pxpay_deposit_trxId", limit: 255
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
    t.decimal  "exchange_amount",                 precision: 12, scale: 2, default: 0.0
    t.decimal  "exchange_rate",                   precision: 12, scale: 2, default: 0.0
    t.string   "pxpay_balance_trxId"
    t.string   "pxpay_deposit_url"
    t.string   "pxpay_balance_url"
  end

  add_index "invoices", ["pxpay_balance_trxId"], name: "index_invoices_on_pxpay_balance_trxId", using: :btree
  add_index "invoices", ["pxpay_deposit_trxId"], name: "index_invoices_on_pxpay_deposit_trxId", using: :btree

  create_table "itineraries", force: :cascade do |t|
    t.string   "name"
    t.date     "start_date"
    t.integer  "num_passengers"
    t.boolean  "complete"
    t.boolean  "sent"
    t.boolean  "quality_check"
    t.text     "includes"
    t.text     "excludes"
    t.text     "notes"
    t.string   "flight_reference"
    t.integer  "user_id"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "itinerary_template_id"
    t.integer  "enquiry_id"
    t.string   "status"
    t.integer  "destination_image_id"
    t.datetime "quote_sent"
    t.datetime "confirmed_itinerary_sent"
    t.integer  "agent_id"
    t.integer  "lead_customer_id"
    t.date     "end_date"
    t.integer  "bedding_type",             default: 0
  end

  add_index "itineraries", ["customer_id"], name: "index_itineraries_on_customer_id", using: :btree
  add_index "itineraries", ["enquiry_id"], name: "index_itineraries_on_enquiry_id", using: :btree
  add_index "itineraries", ["itinerary_template_id"], name: "index_itineraries_on_itinerary_template_id", using: :btree
  add_index "itineraries", ["user_id"], name: "index_itineraries_on_user_id", using: :btree

  create_table "itinerary_infos", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "position"
    t.integer  "supplier_id"
    t.integer  "itinerary_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "length"
    t.text     "comment_for_supplier"
    t.text     "comment_for_customer"
    t.integer  "room_type"
    t.boolean  "includes_breakfast"
    t.boolean  "includes_lunch"
    t.boolean  "includes_dinner"
    t.string   "group_classification"
    t.text     "product_description"
  end

  add_index "itinerary_infos", ["itinerary_id"], name: "index_itinerary_infos_on_itinerary_id", using: :btree
  add_index "itinerary_infos", ["product_id"], name: "index_itinerary_infos_on_product_id", using: :btree
  add_index "itinerary_infos", ["supplier_id"], name: "index_itinerary_infos_on_supplier_id", using: :btree

  create_table "itinerary_price_items", force: :cascade do |t|
    t.string   "booking_ref"
    t.string   "description"
    t.decimal  "price_total",                 precision: 12, scale: 2, default: 0.0
    t.integer  "supplier_id"
    t.integer  "itinerary_price_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supplier_itinerary_price_id"
    t.integer  "invoice_id"
    t.integer  "quantity",                                             default: 0
    t.decimal  "item_price",                  precision: 12, scale: 2, default: 0.0
    t.integer  "deposit_percentage",                                   default: 0
    t.date     "start_date"
    t.integer  "currency_id"
    t.integer  "markup_percentage"
    t.date     "end_date"
    t.decimal  "sell_currency_rate",          precision: 12, scale: 2, default: 0.0
    t.decimal  "deposit",                     precision: 12, scale: 2, default: 0.0
    t.decimal  "markup",                      precision: 12, scale: 2, default: 0.0
    t.decimal  "exchange_rate_total",         precision: 12, scale: 2, default: 0.0
    t.decimal  "total_incl_markup",           precision: 12, scale: 2, default: 0.0
    t.boolean  "supplier_quote_sent"
    t.boolean  "supplier_request_sent"
    t.boolean  "supplier_check_sent"
    t.boolean  "supplier_invoice_matched"
    t.boolean  "invoice_matched",                                      default: false
  end

  add_index "itinerary_price_items", ["itinerary_price_id"], name: "index_itinerary_price_items_on_itinerary_price_id", using: :btree
  add_index "itinerary_price_items", ["supplier_id"], name: "index_itinerary_price_items_on_supplier_id", using: :btree

  create_table "itinerary_prices", force: :cascade do |t|
    t.integer  "itinerary_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "deposit_due"
    t.date     "invoice_date"
    t.date     "balance_due"
    t.date     "final_balance_due"
    t.boolean  "locked",                                              default: false
    t.integer  "currency_id"
    t.decimal  "deposit",                    precision: 12, scale: 2, default: 0.0
    t.decimal  "sale_total",                 precision: 12, scale: 2, default: 0.0
    t.boolean  "deposit_system_default",                              default: false
    t.date     "booking_confirmed_date"
    t.boolean  "booking_confirmed"
    t.date     "customer_invoice_sent_date"
    t.boolean  "customer_invoice_sent"
  end

  add_index "itinerary_prices", ["itinerary_id"], name: "index_itinerary_prices_on_itinerary_id", using: :btree

  create_table "itinerary_template_infos", force: :cascade do |t|
    t.integer  "position"
    t.integer  "length"
    t.integer  "days_from_start"
    t.integer  "product_id"
    t.integer  "itinerary_template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supplier_id"
    t.integer  "room_type"
    t.boolean  "includes_breakfast"
    t.boolean  "includes_lunch"
    t.boolean  "includes_dinner"
    t.string   "group_classification"
  end

  add_index "itinerary_template_infos", ["itinerary_template_id"], name: "index_itinerary_template_infos_on_itinerary_template_id", using: :btree
  add_index "itinerary_template_infos", ["product_id"], name: "index_itinerary_template_infos_on_product_id", using: :btree

  create_table "itinerary_templates", force: :cascade do |t|
    t.string   "name"
    t.text     "includes"
    t.text     "excludes"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "itinerary_default_image_id"
  end

  create_table "job_progresses", force: :cascade do |t|
    t.string   "name"
    t.integer  "total"
    t.integer  "progress"
    t.boolean  "complete"
    t.boolean  "started"
    t.text     "summary"
    t.text     "log"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "import_file"
    t.string   "job_type"
    t.boolean  "run_live"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "invoice_id"
    t.decimal  "item_price",              precision: 12, scale: 2, default: 0.0
    t.decimal  "total",                   precision: 12, scale: 2, default: 0.0
    t.string   "description", limit: 255
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deposit"
  end

  create_table "payments", force: :cascade do |t|
    t.decimal  "amount",                         precision: 12, scale: 5, default: 0.0
    t.string   "payment_ref",        limit: 255
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "reference"
    t.date     "date"
    t.boolean  "cc_payment",                                              default: false
    t.string   "cc_payment_ref"
    t.string   "cc_client_info"
    t.boolean  "receipt_triggered",                                       default: false
    t.string   "payment_type"
    t.integer  "itinerary_price_id"
  end

  create_table "products", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.text     "description"
    t.decimal  "price_single",         precision: 12, scale: 2
    t.decimal  "price_double",         precision: 12, scale: 2
    t.decimal  "price_triple",         precision: 12, scale: 2
    t.string   "room_type"
    t.string   "rating"
    t.string   "destination"
    t.integer  "default_length"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.integer  "country_id"
    t.integer  "destination_id"
    t.string   "country_search"
    t.string   "destination_search"
    t.string   "image_remote_url"
    t.integer  "hotel_id"
    t.text     "address"
    t.string   "phone"
    t.integer  "cruise_id"
    t.string   "group_classification"
    t.boolean  "includes_breakfast"
    t.boolean  "includes_lunch"
    t.boolean  "includes_dinner"
  end

  add_index "products", ["cruise_id"], name: "index_products_on_cruise_id", using: :btree
  add_index "products", ["hotel_id"], name: "index_products_on_hotel_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string "name"
  end

  create_table "settings", force: :cascade do |t|
    t.string   "company_name",               limit: 255
    t.string   "pxpay_user_id",              limit: 255
    t.string   "pxpay_key",                  limit: 255
    t.boolean  "use_xero"
    t.string   "xero_consumer_key",          limit: 255
    t.string   "xero_consumer_secret",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id"
    t.string   "payment_gateway",            limit: 255
    t.decimal  "cc_mastercard",                          precision: 5, scale: 4
    t.decimal  "cc_visa",                                precision: 5, scale: 4
    t.decimal  "cc_amex",                                precision: 5, scale: 4
    t.string   "dropbox_user"
    t.text     "dropbox_session"
    t.boolean  "use_dropbox"
    t.string   "dropbox_default_path"
    t.text     "itinerary_includes"
    t.text     "itinerary_excludes"
    t.text     "itinerary_notes"
    t.integer  "itinerary_default_image_id"
    t.integer  "company_logo_id"
    t.boolean  "send_emails_turned_off"
    t.text     "quote_introduction"
    t.text     "confirmed_introduction"
    t.integer  "num_days_balance_due",                                           default: 95
    t.integer  "num_days_deposit_due",                                           default: 7
    t.integer  "deposit_percentage",                                             default: 0
    t.string   "itineraries_from_email"
    t.text     "important_notes"
    t.text     "overide_email_addresses"
    t.boolean  "overide_emails"
    t.string   "pin_payment_public_key"
    t.string   "pin_payment_secret_key"
    t.text     "invoice_banking_details"
    t.text     "invoice_company_address"
    t.text     "invoice_company_contact"
    t.text     "invoice_footer"
    t.string   "pin_payment_url"
    t.string   "base_url"
    t.text     "about_company"
  end

  create_table "stopovers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "user_roles", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "user_roles", ["user_id", "role_id"], name: "index_user_roles_on_user_id_and_role_id", unique: true, using: :btree

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
    t.integer  "profile_image_id"
    t.string   "phone"
    t.text     "profile_description"
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
    t.decimal  "amount_due",                 precision: 12, scale: 5, default: 0.0
    t.decimal  "amount_paid",                precision: 12, scale: 5, default: 0.0
    t.decimal  "total",                      precision: 12, scale: 5, default: 0.0
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
