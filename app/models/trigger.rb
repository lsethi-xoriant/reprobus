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

  # CLASS METHODS
  def self.send_mail(trigger, cc, to)
    @trigger = trigger
    @cc = cc
    @to = to
    
    # only send email if the trigger has an associated email template
    if @trigger.email_template
      if @trigger.num_days.blank? || @trigger.num_days == 0
        # do job now.
        SendEmailTemplateJob.perform_later(@trigger.email_template, @cc, @to)
      else
        # do job in a number of days.
        secs = 0
        secs = @trigger.num_days * 60 * 60 * 24
        SendEmailTemplateJob.set(wait: secs.seconds).perform_later(@trigger.email_template, @cc, @to)
      end
      return true
    end
    return false
  end
  
  def self.trigger_new_enquiry(enquiry)
    @trigger = Setting.find(1).triggers.find_by_name("New Enquiry")
    @enquiry = enquiry
    
    Trigger.send_mail(@trigger, @enquiry.user.email, @enquiry.customer_email)
  end
  
  def self.trigger_new_booking(booking)
    @trigger = Setting.find(1).triggers.find_by_name("New Booking")
    @booking = booking
    
    Trigger.send_mail(@trigger, @booking.user.email, @booking.enquiry.customer_email)
  end
  
  def self.trigger_pay_receipt(invoice, payment)
    @trigger = Setting.find(1).triggers.find_by_name("Payment Received")
    @invoice = invoice
    @booking = @invoice.booking
    if !payment.receipt_triggered
      if Trigger.send_mail(@trigger, @booking.user.email, @booking.enquiry.customer_email)
        payment.update_attribute(:receipt_triggered, true)
      end
    end
  end
end
