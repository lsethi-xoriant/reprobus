# == Schema Information
#
# Table name: tours
#
#  id          :integer          not null, primary key
#  tourName    :string(255)
#  destination :string(255)
#  country     :string(255)
#  tourPrice   :decimal(, )
#  created_at  :datetime
#  updated_at  :datetime
#  image       :string(255)
#

class Tour < ActiveRecord::Base
  validates :tourName, presence: true, length: { maximum: 250 }
  mount_uploader :image, ImageUploader
end
