# == Schema Information
#
# Table name: image_holders
#
#  id               :integer          not null, primary key
#  image_local      :string
#  image_remote_url :string
#  created_at       :datetime
#  updated_at       :datetime
#

class ImageHolder < ActiveRecord::Base
  mount_uploader :image_local, ImageUploader
    
  def hasImage?
    if Setting.global_settings.use_dropbox && !self.image_remote_url.blank?
      return true
    elsif self.image_local_url()
      return true;
    end;
  end
    
  def get_dropbox_image_link
    if !self.image_remote_url.blank?
      return DropboxHelper.get_db_image_link_url(self.image_remote_url)
    else
      return ActionController::Base.helpers.image_path('noImage.jpg')
    end
  end    
  
  def get_image_link
    if Setting.global_settings.use_dropbox 
      return self.get_dropbox_image_link()
    else 
      return self.image_local_url()
    end 
  end
end
