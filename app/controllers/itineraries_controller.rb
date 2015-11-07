class ItinerariesController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user, only: :destroy
  before_action :setCompanySettings

  def printItinerary
    @itinerary = Itinerary.find(params[:itinerary_id])
    @enquiry = @itinerary.enquiry

    respond_to do |format|
      format.pdf do
        render pdf: "Itinerary_no_" + @itinerary.id.to_s.rjust(8, '0'),
               show_as_html: params.key?('debug')
        
        #,
               #footer:  {   html: {   template:'itineraries/print_itinerary/footer.pdf.erb',
               #                       layout: false
               #}}
      end
      format.html { render layout: false }
    end    
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
    @itinerary.itinerary_default_image = ImageHolder.new if !@itinerary.itinerary_default_image
  end

  def show
    @itinerary = Itinerary.find(params[:id])
    @enquiry = @itinerary.enquiry
  end
  
  def edit
    @itinerary = Itinerary.includes(:itinerary_infos).find(params[:id])
    @enquiry = @itinerary.enquiry
    @itinerary.itinerary_default_image = ImageHolder.new if !@itinerary.itinerary_default_image
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
  
private
    def itinerary_params
      params.require(:itinerary).permit(:name, :includes, :excludes, :notes, :itinerary_template_id,
      :enquiry_id, :start_date, :num_passengers, :complete, :sent, :quality_check, :flight_reference, 
      :user_id, :status,  itinerary_infos_attributes: [:id, :position, :name, :product_id, :start_date, 
      :end_date, :country, :length, :city, :product_type, :product_name, :rating, :room_type, 
      :supplier_id, :includes_breakfast, :includes_lunch, :includes_dinner, :group_classification,
      :comment_for_customer, :comment_for_supplier, :offset,  :_destroy ],
      itinerary_default_image_attributes: [:id, :image_local, :image_remote_url])
    end
end

 