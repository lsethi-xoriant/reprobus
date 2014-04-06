class CreateEnquiries < ActiveRecord::Migration
  def change
    create_table :enquiries do |t|
      t.integer  "user_id"
      t.integer  "assigned_to"
      t.string   "name",             :limit => 64,                                :default => "",       :null => false
      t.string   "access",           :limit => 8,                                 :default => "Public"
      t.string   "source",           :limit => 32
      t.string   "stage",            :limit => 32
      t.integer  "probability"
      t.decimal  "amount",                         :precision => 12, :scale => 2
      t.decimal  "discount",                       :precision => 12, :scale => 2
      t.date     "closes_on"
      t.datetime "deleted_at"
      t.string   "background_info"
      t.text     "subscribed_users"
     
      t.timestamps
    end
    
    add_index "enquiries", ["assigned_to"], :name => "index_opportunities_on_assigned_to"    
  end
end
