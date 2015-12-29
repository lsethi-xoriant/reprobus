class ItinerariesController < ApplicationController
  authorize_resource class: ItinerariesController
  
  before_filter :signed_in_user
  # before_filter :admin_user, only: :destroy
  before_action :setCompanySettings

  def printQuote
    @itinerary = Itinerary.find(params[:itinerary_id])
    @enquiry = @itinerary.enquiry
    @confirmed = params[:confirmed].present?

    respond_to do |format|
      format.pdf do
        render  pdf: "Itinerary_no_" + @itinerary.id.to_s.rjust(8, '0'),
                show_as_html: params.key?('debug'),
                margin: { bottom: 15 },
                footer: { html: 
                          { 
                            template:'itineraries/print_itinerary/footer.pdf.erb',
                            layout: false
                          }
                        }
      end
      format.html { render layout: false }
    end    
  end

  def printConfirmed
  end

  def emailQuote
    @itinerary = Itinerary.find(params[:email_settings][:id])
    
    if CustomerMailer.send_email_quote(
      @itinerary, @setting, params[:email_settings]).deliver

      @itinerary.quote_sent_update_date
      flash[:success] = 'Itinerary Quote has been sent.'
    else
      flash[:error] = 'Error occured while sending Quote'
    end
    
    redirect_to edit_itinerary_path(params[:itinerary_id])
  end

  def index
    respond_to do |format|
      format.html
      format.json { render json: ItineraryDatatable.new(view_context) }
    end
  end
  
  def new
    @enquiry = Enquiry.find(params[:enquiry_id])
    if !@enquiry
      flash[:error] = "No enquiry, cannot create itinerary!"
      redirect_to enquiries_path
    end
    
    @itinerary = Itinerary.new
    @itinerary.user = current_user
    @itinerary.status = "Itinerary"
    @itinerary.enquiry = @enquiry
    @itinerary.num_passengers = @enquiry.num_people
    @itinerary.start_date = @enquiry.est_date
    @itinerary.name = @enquiry.name

  end

  def show
    @itinerary = Itinerary.find(params[:id])
    @enquiry = @itinerary.enquiry
  end
  
  def edit
    @itinerary = Itinerary.includes(:itinerary_infos).find(params[:id])
    @enquiry = @itinerary.enquiry
    @destinations = @itinerary
                      .itinerary_infos
                      .map(&:product)
                      .map { |product| product.destination if product }
                      .compact
                      .uniq

    set_email_modal_values
  end
  
  def create
    @itinerary = Itinerary.new(itinerary_params)
    @enquiry = Enquiry.find(params[:itinerary][:enquiry_id])
     
    @itinerary.copy_template(@itinerary.itinerary_template)

    @itinerary.customers = @enquiry.customers
    @itinerary.agent = @enquiry.agent
    @itinerary.lead_customer = @enquiry.lead_customer
     
    if @itinerary.save
      @itinerary.enquiry.stage = "Itinerary"
      @itinerary.enquiry.save
      flash[:success] = "Itinerary created!"
      redirect_to  edit_itinerary_path(@itinerary)
    else
      render 'new'
    end
  end

  def update
    @itinerary = Itinerary.find(params[:id])
    @enquiry = @itinerary.enquiry

    if params[:itinerary] && params[:itinerary][:customers_attributes]
      params[:itinerary][:customers_attributes].each do |key, value|
        if !value[:id].to_s.blank? #existing customer
          @customer = Customer.find(value[:id])
          @itinerary.customers << @customer unless @itinerary.customers.include?(@customer)
        end
      end
    end

    @itinerary.end_date = @itinerary.get_end_date

    if @itinerary.update_attributes(itinerary_params)
      
      if (params.has_key?(:itinerary_template_insert) && params[:itinerary_template_insert].to_i >= 0) 
        @itinerary.insert_template(params[:itinerary_template_insert].to_i, params[:insert_position].to_i)
        if !@itinerary.save
          flash[:warning] = "Problem inserting template"
          render 'edit'
          return
        end
      end 
      
      flash[:success] = "Itinerary updated"
      redirect_to edit_itinerary_path(@itinerary)
    else
      render 'edit'
    end
  end

  def details
    @itinerary = Itinerary.find(params[:id])
    @enquiry = @itinerary.enquiry
    set_customers_for_itinerary
    @customer = @itinerary.lead_customer
  end

  def destroy
    Itinerary.find(params[:id]).destroy
    flash[:success] = "Itinerary deleted."
    redirect_to itinerary_templates_url
  end

  def copy
    itinerary_copy = ItineraryCloneService.clone(params[:copy], current_user)
    if itinerary_copy.try(:save)
      flash[:success] = "Itinerary succesfully copied"
      itinerary_id = itinerary_copy.id
    else
      flash[:error] = "Error while copying Itinerary"
      itinerary_id = params[:id]
    end
    redirect_to edit_itinerary_path(itinerary_id)
  end

  def cancel
    @itinerary = Itinerary.find(params[:id])
    if @itinerary.cancel
      undo_link = view_context.link_to("(Undo Cancel)",
      revert_cancel_itinerary_path(@itinerary), :method => :post)
      flash[:success] = "Itinerary cancelled. #{undo_link}"
    else
      flash[:error] = "Error while cancelling Itinerary"
    end
    redirect_to edit_itinerary_path(@itinerary)
  end

  def revert_cancel
    @itinerary = Itinerary.find(params[:id])
    if @itinerary.update_attributes(status: 'Reinstated')
      flash[:success] = "Itinerary reinstated"
    else
      flash[:error] = "Error while undo cancelling Itinerary"
    end
    redirect_to edit_itinerary_path(@itinerary)
  end

  def customer_interactions
    @customer_interactions = CustomerInteraction.where(itinerary_id: params[:id])
    respond_to do |format|
      format.html
    end 
  end

  def customer_updates
    itinerary = Itinerary.find(params[:id])
    CustomerMailer.send_profile_update_requests(
      itinerary, request, params[:customer_update][:send_to]).deliver
    redirect_to edit_itinerary_path(params[:id])
  end
  
private
    def itinerary_params
      params.require(:itinerary).permit(:name, :includes, :excludes, :notes, :itinerary_template_id,
      :enquiry_id, :start_date, :num_passengers, :complete, :sent, :quality_check, :flight_reference,
      :destination_image_id, :user_id, :status, :quote_sent, :agent_id, :bedding_type,
      itinerary_infos_attributes: [:id, :position, :product_id, :start_date,
      :end_date, :length, :room_type, :supplier_id, :includes_breakfast, :includes_lunch, :includes_dinner, 
      :group_classification, :comment_for_customer, :comment_for_supplier,  :_destroy ],
      customers_attributes: [:id, :first_name, :last_name, :email, :phone, :mobile, :title, :lead_customer, :_destroy])
    end

    def set_email_modal_values
      @lead_customer = @enquiry.customer_name_and_title
      @agent_name = @enquiry.agent_name_and_title
      @to_email = 
        @enquiry.agent.try(:email).presence || @itinerary.lead_customer.try(:email)

      @from_email = 
        @setting.try(:itineraries_from_email).presence || User.find_by_name("System").try(:email)
    end

    def set_customers_for_itinerary
      @itinerary.customers = @itinerary.customers.any? ? @itinerary.customers : @enquiry.customers
      @itinerary.agent = @itinerary.agent ? @itinerary.agent : @enquiry.agent
      @itinerary.lead_customer = @itinerary.lead_customer ? @itinerary.lead_customer : @enquiry.lead_customer
    end
end
