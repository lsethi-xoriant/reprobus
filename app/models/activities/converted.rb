# == Schema Information
#
# Table name: activities
#
#  id          :integer          not null, primary key
#  type        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  customer_id :integer
#  user_id     :integer
#  user_email  :string(255)
#  enquiry_id  :integer
#

class Converted < Activity
  # Methods, variables and constants
end
