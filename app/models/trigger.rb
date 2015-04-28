# == Schema Information
#
# Table name: triggers
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  num_days          :integer
#  setting_id        :integer
#  created_at        :datetime
#  updated_at        :datetime
#  email_template_id :integer
#

class Trigger < ActiveRecord::Base
  belongs_to :email_template
  
  def email_template_name
   self.email_template ? self.email_template.name : ""
  end
  
#  def email_template_id
#    self.email_template ? self.email_template.id.to_s : "0"
#  end
end
