class AddActivities < ActiveRecord::Migration

  def change
    add_column :customers, :issue_date, :date    
    add_column :customers, :expiry_date, :date    
    add_column :customers, :place_of_issue, :string
    add_column :customers, :passport_num, :string
    add_column :customers, :insurance, :string
    add_column :customers, :gender, :string           
  end

  create_table :activities do |t|
    t.text :type
    t.text :description
    t.timestamps
  end    

  create_table :customer_activities do |t|
    t.belongs_to :activity 
    t.belongs_to :customer
    t.timestamps
  end

  create_table :user_activities do |t|
    t.belongs_to :activity 
    t.belongs_to :user
    t.timestamps
  end

end
