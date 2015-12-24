class CustomerMailer < ActionMailer::Base
  default from: "donotreply@tripease.com"
  helper :application
  
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

  def send_email_quote(itinerary, setting, confirmed=false, params)
    # In development emails are opened by letter opener
    # Bring back this if its necessery:
    # if !Setting.global_settings.send_emails_turned_off
    type = confirmed ? :confirmed_itinerary : :quote
    name = confirmed ? 'Confirmed Itinerary' : 'Itinerary Quote'
    include_cc = ActiveRecord::Type::Boolean.new.type_cast_from_user(params[:cc_email_send])
    mail(
      from: params[:from_email],
      reply_to: params[:from_email],
      to: params[:to_email],
      cc: include_cc ? params[:cc_email] : '',
      subject: name) do |format|
        format.html { render layout: false }
        format.pdf do
          if params[:type] == 'PDF'
            attachments["#{name.delete(' ')}.pdf"] = 
              ItineraryRenderService.as_pdf(itinerary, setting, confirmed)
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

    BookingHistoryService.record_interaction(attachments, type, params)
  end

  def send_email_supplier_quote(itinerary, itinerary_price, itinerary_price_item, itinerary_infos, supplier, confirmed=false, params)
    @body = params[:body]
    @confirmed = confirmed
    @itinerary = itinerary
    params[:id] = @itinerary.id

    bulk_action = ActiveRecord::Type::Boolean.new.type_cast_from_user(params[:bulk_action])
    flight_details = bulk_action ? params["flight_details_1"] : params["flight_details_#{itinerary_price_item.id}"]

    include_cc = ActiveRecord::Type::Boolean.new.type_cast_from_user(params[:cc_email_send])
    name = confirmed ? "#{supplier.try(:supplier_name)} booking request #{itinerary.id} / #{itinerary.try(:lead_customer).try(:last_name)}" : "Supplier Quote"
    type = confirmed ? :confirmed_supplier : :supplier_quote

    mail(
      from: params[:from_email],
      reply_to: params[:from_email],
      to: params[:to_email],
      cc: include_cc ? params[:cc_email] : '',
      subject: name) do |format|
        format.html { render layout: false }
        format.pdf do
          if params[:type] == 'PDF'
            attachments['supplier.pdf'] = 
              SupplierRenderService.as_pdf(itinerary, itinerary_price, itinerary_price_item, itinerary_infos, supplier, confirmed, flight_details)
          end
        end
      end

    BookingHistoryService.record_interaction(attachments, type, params)
  end

  def send_profile_update_requests(itinerary, request, send_to)
    @lead_customer = itinerary.lead_customer
    @customers = itinerary.customers
    @request = request
    @send_to = send_to

    update_customers_tokens_and_expiry_dates(@customers)

    case @send_to
    when 'lead_customer'
      send_update_request(@lead_customer.try(:email))
    when 'individual_customers'
      @customers.each do |customer| 
        @current_customer = customer
        send_update_request(customer.email)
      end
    end
  end

  private

    def update_customers_tokens_and_expiry_dates(customers)
      customers.each do |customer|
        customer.update_attributes(
          { 
            public_edit_token: User.new_remember_token, 
            public_edit_token_expiry: 7.days.from_now.to_date
          }
        )
      end
    end

    def send_update_request(to_email)
      from_email = 
        Setting.find(1).try(:itineraries_from_email).presence || 
          User.find_by_name("System").try(:email)
      mail(
        from: from_email,
        reply_to: from_email,
        to: to_email, 
        subject: 'Update personal details') if to_email.present?
    end

    def send_lead_customer_update(lead_customer)
      token = User.new_remember_token
      date = 7.days.from_now.to_date
      
    end
end
