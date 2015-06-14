# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#

class Country < Admin
    validates :name, presence: true, length: { maximum: 255 }
end
