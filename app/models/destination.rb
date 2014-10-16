# == Schema Information
#
# Table name: destinations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Destination < Admin
   has_and_belongs_to_many :enquiries
end
