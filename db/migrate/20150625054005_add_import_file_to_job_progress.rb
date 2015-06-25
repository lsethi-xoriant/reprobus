class AddImportFileToJobProgress < ActiveRecord::Migration
  def change
    add_column :job_progresses, :import_file, :string
  end
end
