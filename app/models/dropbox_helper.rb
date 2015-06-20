class DropboxHelper
  
  require 'rubygems'
  require 'dropbox_sdk'

  DROPBOX_APP_KEY = ENV["DROPBOX_APP_KEY"]
  DROPBOX_APP_KEY_SECRET = ENV["DROPBOX_APP_KEY_SECRET"]

  def self.get_db_image_link_url(imageName)
    setting = Setting.find(1)
    
    if setting.use_dropbox && setting.use_dropbox
      dbsession = DropboxSession.deserialize(setting.dropbox_session)
      client = DropboxClient.new(dbsession)
      link = client.media(imageName)
      hash = HashWithIndifferentAccess.new(link)
  
      return hash[:url]  
    end
  end
end