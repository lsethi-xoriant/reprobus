# == Schema Information
#
# Table name: stopovers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Stopover < Admin
   has_and_belongs_to_many :enquiries
   validates :name, presence: true, length: { maximum: 255 }
end
