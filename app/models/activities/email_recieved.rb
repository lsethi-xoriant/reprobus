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
#

# This class uses Single Table Inheritance (STI)

class EmailRecieved < Activity
  # Methods, variables and constants
end
