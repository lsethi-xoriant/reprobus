class RenameConfig < ActiveRecord::Migration
  def change
    rename_table :configurations, :settings
  end
end
