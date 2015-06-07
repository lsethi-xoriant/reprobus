class ItinerariesController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user, only: :destroy
  
  def index
    @itineraries = Itinerary.paginate(page: params[:page])
  end
  
  def new
    @enquiry = Enquiry.find(params[:enquiry_id])
    if !@enquiry
      flash[:error] = "No enquiry, cannot create itinerary!"
      redirect_to enquiries_path
    end
    
    @itinerary = Itinerary.new
  end

  def show
    @itinerary = Itinerary.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: {name: @itinerary.fullname, id: @itinerary.id  }}
    end
  end
  
  def edit
    @itinerary = Itinerary.find(params[:id])
  end
  
  def create
    @itinerary = Itinerary.new(itinerary_params)
    @template =  ItineraryTemplate.find(params[:itinerary_template_id])
    
    @itinerary.copy_template(@template)
    
    if @itinerary.save
      flash[:success] = "Template created!"
      redirect_to  edit_itinerary_path(@itinerary)
    else
      render 'new'
    end
  end

  def update
     @itinerary = Itinerary.find(params[:id])
     
    if @itinerary.update_attributes(itinerary_params)
      flash[:success] = "Template updated"
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
      params.require(:itinerary).permit(:name, :includes, :excludes, :notes,
      itinerary_infos_attributes: [:id, :position, :name, :product_id, :start_date,
      :end_date, :country, :city, :product_type, :product_name, :rating, :room_type,
      :supplier_id,  :_destroy ])
      
    end
end
