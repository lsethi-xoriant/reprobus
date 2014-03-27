class Tour < ActiveRecord::Base
  validates :tourName, presence: true, length: { maximum: 250 }
  mount_uploader :image, ImageUploader
end
