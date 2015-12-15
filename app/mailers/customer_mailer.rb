class CustomerMailer < ActionMailer::Base
  default from: "donotreply@tripease.com"
  
  # include SessionsHelper
  # before_action :setCompanySettings, only: [:send_email_quote]

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.customer_mailer.password_reset.subject
  #
  def send_trigger_email(email_template, cc_user, to_email)
    @email_template = email_template
    
    @email_template.from_name.blank? ? from_name = "" : from_name = @email_template.from_name
    if @email_template.copy_assigned_user
      cc = cc_user
    else
      cc = ""
    end
    
    if !Setting.global_settings.send_emails_turned_off
      mail(to: to_email, subject: @email_template.subject, reply_to: @email_template.from_email,
         from: from_name, cc: cc)
    end
  end

  def send_email_quote(itinerary, setting, params)
    # In development emails are opened by letter opener
    # Bring back this if its necessery:
    # if !Setting.global_settings.send_emails_turned_off
    mail(
      from: params[:from_email],
      reply_to: params[:from_email],
      to: params[:to_email], 
      subject: "Itinerary Quote") do |format|
        format.html { render layout: false }
        format.pdf do
          if params[:type] == 'PDF'
            @attachment = 
              ItineraryRenderService.as_pdf(itinerary, setting)
            attachments['ItineraryQuote.pdf'] = @attachment
          end
        end
        # TODO: need to be updated after Editable Format will be implemented
        # format.something do
        #   if params[:type] == 'Rich Text Document'
        #     attachments['ItineraryQuote.something'] = render_itinerary_as_something(params)
        #   end
        # end
      end
    # end

    file = StringIO.new(attachments['ItineraryQuote.pdf'].decoded)
    file.class.class_eval { attr_accessor :original_filename, :content_type }
    file.original_filename = attachments['ItineraryQuote.pdf'].filename
    file.content_type = attachments['ItineraryQuote.pdf'].mime_type

    options = 
    {
      emailed_at: DateTime.now,
      emailed_to: params[:to_email],
      document_type: :quote,
      attachment: file,
      itinerary_id: params[:id]
    }
    customer_interaction = CustomerInteraction.new(options)
    customer_interaction.save

  end
end
