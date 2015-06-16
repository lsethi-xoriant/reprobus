class ItinerariesController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user, only: :destroy
  
  def index
    respond_to do |format|
      format.html
      format.json { render json: ItineraryDatatable.new(view_context, { user: current_user }) }
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
  end

  def show
    @itinerary = Itinerary.find(params[:id])
  end
  
  def edit
    @itinerary = Itinerary.find(params[:id])
  end
  
  def create
    @itinerary = Itinerary.new(itinerary_params)

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
     
    if @itinerary.update_attributes(itinerary_params)
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
      :enquiry_id, :start_date, :num_passengers, :complete, :sent, :quality_check, :flight_reference, :user_id,
      itinerary_infos_attributes: [:id, :position, :name, :product_id, :start_date, :end_date, :country, :length,
      :status, :city, :product_type, :product_name, :rating, :room_type, :supplier_id,  :_destroy ])
    end
end
 