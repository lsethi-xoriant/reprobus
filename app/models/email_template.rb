# == Schema Information
#
# Table name: email_templates
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  from_email         :string(255)
#  from_name          :string(255)
#  subject            :string(255)
#  body               :string(255)
#  copy_assigned_user :boolean
#  created_at         :datetime
#  updated_at         :datetime
#

class EmailTemplate < ActiveRecord::Base
  has_many :triggers
  
  def trigger_count
    #self.trigger ? self.trigger.name : ""
  end
end
