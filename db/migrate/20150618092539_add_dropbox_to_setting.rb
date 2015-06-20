class AddDropboxToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :dropbox_user, :string
    add_column :settings, :dropbox_secret, :string
    add_column :settings, :dropbox_key, :string
    add_column :settings, :dropbox_session, :text
    add_column :settings, :use_dropbox, :boolean
  end
end
