class RenameProductRemoteUrl < ActiveRecord::Migration
  def change
    rename_column :products, :remote_url, :image_remote_url
  end
end
