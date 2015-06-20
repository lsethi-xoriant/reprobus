class UpdateDropboxStuff < ActiveRecord::Migration
  def change
    add_column :settings, :dropbox_default_path, :string
    remove_column :settings, :dropbox_key
    remove_column :settings, :dropbox_secret
  end
end
