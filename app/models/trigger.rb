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

  def self.trigger_new_enquiry(enquiry)
    @trigger = Setting.find(1).triggers.find_by_name("New Enquiry")
    @enquiry = enquiry
    
    if @trigger.email_template
      if @trigger.num_days.blank? || @trigger.num_days == 0
        # do job now.
        SendEmailTemplateJob.perform_later(@trigger.email_template,@enquiry.user.email, @enquiry.customer_email)
      else
        # do job in a number of days.
        secs = 0
        secs = @trigger.num_days * 60 * 60 * 24
        SendEmailTemplateJob.set(wait: secs.seconds).perform_later(@trigger.email_template, @enquiry.user.email, @enquiry.customer_email)
      end
    end
  end
end
