class CustomerMailer < ActionMailer::Base
  default from: "donotreply@tripease.com"
  
  include SessionsHelper
  before_action :setCompanySettings, only: [:send_email_quote]

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

  def send_email_quote(params)
    @itinerary = Itinerary.find(params[:id])
    @enquiry = @itinerary.enquiry

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
            attachments['ItineraryQuote.pdf'] = render_itinerary_as_pdf(params)
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
  
  end

  private
    def render_itinerary_as_pdf(params)
      body_html   = 
        render_to_string(
          template: 'itineraries/printQuote.pdf.erb', 
          layout: false
        )

      footer_html = 
        render_to_string(
          template: 'itineraries/print_itinerary/footer.pdf.erb',
          layout: false
        )
      
      WickedPdf.new.pdf_from_string(
        body_html,
        pdf: "Itinerary_no_" + params[:id].to_s.rjust(8, '0'),
        margin: { bottom: 15 },
        footer: { content: footer_html } 
      )
    end

end
