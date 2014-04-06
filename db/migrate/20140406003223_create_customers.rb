class CreateCustomers < ActiveRecord::Migration
  def change  
   
    create_table :customers do |t|
      t.integer  "user_id"
      t.integer  "lead_id"
      t.integer  "assigned_to"
      t.integer  "reports_to"
      t.string   "first_name",       :limit => 64,  :default => "",       :null => false
      t.string   "last_name",        :limit => 64,  :default => "",       :null => false
      t.string   "title",            :limit => 64
      t.string   "source",           :limit => 32
      t.string   "email",            :limit => 64
      t.string   "alt_email",        :limit => 64
      t.string   "phone",            :limit => 32
      t.string   "mobile",           :limit => 32
      t.string   "fax",              :limit => 32
      t.string   "blog",             :limit => 128
      t.string   "linkedin",         :limit => 128
      t.string   "facebook",         :limit => 128
      t.string   "twitter",          :limit => 128
      t.date     "born_on"
      t.boolean  "do_not_call",                     :default => false,    :null => false
      t.datetime "deleted_at"
      t.string   "background_info"
      t.string   "skype",            :limit => 128
      t.timestamps
    end
  end
end
