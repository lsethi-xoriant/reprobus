# == Schema Information
#
# Table name: carriers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Carrier < Admin
  has_and_belongs_to_many :enquiries
  validates :name, presence: true, length: { maximum: 255 }
end
