class DropboxHelper
  
  require 'rubygems'
  require 'dropbox_sdk'

  DROPBOX_APP_KEY = ENV["DROPBOX_APP_KEY"]
  DROPBOX_APP_KEY_SECRET = ENV["DROPBOX_APP_KEY_SECRET"]

  def self.get_db_image_link_url(imageName)
    setting = Setting.find(1)
    
    if !setting.dropbox_default_path.blank?
      imageName =  setting.dropbox_default_path + imageName
    end
    
    if setting.use_dropbox && setting.dropbox_user
      begin
        dbsession = DropboxSession.deserialize(setting.dropbox_session)
        client = DropboxClient.new(dbsession)
        link = client.media(imageName)
        hash = HashWithIndifferentAccess.new(link)
      rescue DropboxError
        return ActionController::Base.helpers.image_path('noImage.jpg')
      end
      
      return hash[:url]
    end
  end
  
  def self.db_path_exists?(path)
    setting = Setting.find(1)
    
    if setting.use_dropbox && setting.dropbox_user
      begin
        dbsession = DropboxSession.deserialize(setting.dropbox_session)
        client = DropboxClient.new(dbsession)
        link = client.metadata(path)
        if link 
          return true;
        end
      rescue DropboxError
        return false
      end
    end
  end
  
end
