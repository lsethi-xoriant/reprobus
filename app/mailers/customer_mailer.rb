class CustomerMailer < ActionMailer::Base
  default from: "donotreply@tripease.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.customer_mailer.password_reset.subject
  #
  def send_trigger_email(email_template, booking)
    @email_template = email_template
    @booking = booking
    
    @email_template.from_name.blank? ? from_name = "" : from_name = @email_template.from_name
    if @email_template.copy_assigned_user
      cc = @booking.user.email
    else
      cc = ""
    end
    
    mail(to: @booking.enquiry.customer_email, subject: @email_template.subject, reply_to: @email_template.from_email,
         from: from_name, cc: cc)
  end

end
