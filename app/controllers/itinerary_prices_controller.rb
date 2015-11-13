class ItineraryPricesController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user, only: :destroy
  before_action :setCompanySettings
  
  def new
    @itinerary = Itinerary.find(params[:itinerary_id])
    if !@itinerary
      flash[:error] = "No itinerary, cannot create pricing!"
      redirect_to itineraries_path
    end
    
    @itinerary_price = ItineraryPrice.new
    @itinerary_price.itinerary = @itinerary   
    @itinerary_price.new_setup()
   
  end
  
  def edit
    @itinerary_price = ItineraryPrice.includes(:itinerary_price_items).find(params[:id])
    @itinerary = @itinerary_price.itinerary
  end
  
  def create
    @itinerary_price = ItineraryPrice.new(itinerary_price_params)
    @itinerary = @itinerary_price.itinerary
    
    if @itinerary_price.save
      @itinerary_price.itinerary.status = "Pricing Created"
      @itinerary_price.itinerary.save
      flash[:success] = "Itinerary Pricing created!"
      redirect_to  edit_itinerary_price_path(@itinerary_price)
    else
      render 'new'
    end
  end

  def update
    @itinerary_price = ItineraryPrice.find(params[:id])
    @itinerary = @itinerary_price.itinerary
    
    if @itinerary_price.update_attributes(itinerary_price_params)
      flash[:success] = "Itinerary Pricing updated"
      redirect_to edit_itinerary_price_path(@itinerary_price)
    else
      render 'edit'
    end
  end

  
private
  def itinerary_price_params
    params.require(:itinerary_price).permit(:itinerary_id, :deposit_due, 
    :invoice_date, :balance_due, :final_balance_due,
    itinerary_price_items_attributes: [:id, :booking_ref, :description, 
    :price_total, :supplier_id, :itinerary_price_id,  :deposit,
    :item_price, :quantity, :_destroy ],
    supplier_itinerary_price_items_attributes: [:id, :booking_ref, :description, 
    :price_total, :supplier_id, :itinerary_price_id,  :deposit,
    :item_price, :quantity, :_destroy ])
  end  
end