class SendEmailTemplateJob < ActiveJob::Base
  queue_as :default

  def perform(emailTemplate, cc_user, to_email)
    @emailTemplate = emailTemplate
    @cc = cc_user
    @to = to_email
    CustomerMailer.send_trigger_email(@emailTemplate, @cc, @to).deliver_later
  end
end
