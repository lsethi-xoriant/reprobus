class AddJobProgress < ActiveRecord::Migration
  def change
    
   create_table :job_progresses do |t|
      t.string    :name
      t.integer   :total
      t.integer   :progress
      t.boolean   :complete
      t.boolean   :started
      t.text      :summary
      t.text      :log
      t.string    :file_path
      t.string    :file_name
      t.timestamps
    end    
  end
  
  
end
