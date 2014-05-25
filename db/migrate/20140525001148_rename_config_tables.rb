class RenameConfigTables < ActiveRecord::Migration
  def change
    rename_table :carrier, :carriers
    rename_table :stopover, :stopovers
    rename_table :destination, :destinations
  end
end
