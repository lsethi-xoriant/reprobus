class ItinerariesController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user, only: :destroy
  before_action :setCompanySettings

  def printQuote
    @itinerary = Itinerary.find(params[:itinerary_id])
    @enquiry = @itinerary.enquiry

    respond_to do |format|
      format.pdf do
        render pdf: "Itinerary_no_" + @itinerary.id.to_s.rjust(8, '0'),
               show_as_html: params.key?('debug'),
               margin:  { :bottom => 15 },
               footer:  {   html: {   template:'itineraries/print_itinerary/footer.pdf.erb',
                                      layout: false
               }}
      end
      format.html { render layout: false }
    end    
  end

  def emailQuote
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
    @itinerary.status = "New Itinerary"
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

  def destroy
    Itinerary.find(params[:id]).destroy
    flash[:success] = "Itinerary deleted."
    redirect_to itinerary_templates_url
  end

  def copy
    itinerary_copy = ItineraryCloneService.clone(params[:copy])
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
      flash[:success] = "Itinerary cancelled"
    else
      flash[:error] = "Error while cancelling Itinerary"
    end
    redirect_to edit_itinerary_path(@itinerary)
  end
  
private
    def itinerary_params
      params.require(:itinerary).permit(:name, :includes, :excludes, :notes, :itinerary_template_id,
      :enquiry_id, :start_date, :num_passengers, :complete, :sent, :quality_check, :flight_reference,
      :destination_image_id, :user_id, :status,
      itinerary_infos_attributes: [:id, :position, :product_id, :start_date,
      :end_date, :length, :room_type, :supplier_id, :includes_breakfast, :includes_lunch, :includes_dinner, 
      :group_classification, :comment_for_customer, :comment_for_supplier,  :_destroy ])
    end

    def set_email_modal_values
      @lead_customer = @enquiry.customer_name_and_title
      @agent_name = @enquiry.agent_name_and_title
      @to_email = 
        @enquiry.agent.try(:email).presence || @itinerary.user.try(:email)
      @from_email = @setting.try(:itineraries_from_email)
    end
end
