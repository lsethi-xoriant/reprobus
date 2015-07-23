class ItineraryPricesController < ApplicationController
#HALFWAY SET UP - might not need it... 

  before_filter :signed_in_user
  before_filter :admin_user, only: :destroy
  
 
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
  end

  def show
    @itinerary = Itinerary.find(params[:id])
    @enquiry = @itinerary.enquiry
  end
  
  def edit
    @itinerary = Itinerary.includes(:itinerary_infos).find(params[:id])
    @enquiry = @itinerary.enquiry
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
    params.require(:itinerary).permit(:itinerary_id,  itinerary_price_items_attributes: [:id, :booking_ref, :description, :price_total, 
    :supplier_id, :itinerary_price_id, 
    :country, :length, :city, :product_type, :product_name, :rating, :room_type, :supplier_id,
    :comment_for_customer, :comment_for_supplier, :_destroy ])
  end  
  
#  id                 :integer          not null, primary key
#  booking_ref        :string
#  description        :string
#  price_total        :decimal(12, 2)   default("0.0")
#  supplier_id        :integer
#  itinerary_price_id :integer
#  created_at         :datetime
#  updated_at         :datetime
end