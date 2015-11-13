class AddDefaultSuppsToSetting < ActiveRecord::Migration
  def change
    add_column :customers, :setting_id, :integer
  end
end
