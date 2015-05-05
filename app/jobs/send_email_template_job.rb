class SendEmailTemplateJob < ActiveJob::Base
  queue_as :default

  def perform(emailTemplate, booking)
    @emailTemplate = emailTemplate
    @booking = booking
    CustomerMailer.send_trigger_email(@emailTemplate, @booking).deliver_later
  end
end
