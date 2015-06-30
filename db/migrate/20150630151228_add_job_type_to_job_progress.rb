class AddJobTypeToJobProgress < ActiveRecord::Migration
  def change
    add_column :job_progresses, :job_type, :string
    add_column :job_progresses, :run_live, :boolean
  end
end
