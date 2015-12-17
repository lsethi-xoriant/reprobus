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

  def invoice
    @itinerary_price = ItineraryPrice.find(params[:id])
    
    if !@itinerary_price.has_uninvoiced_customer_items
      flash[:error] = "No items requiring invoices!"
      redirect_to edit_itinerary_price_path(@itinerary_price)
    end
    
    if  @itinerary_price.create_customer_invoices(current_user) 
      flash[:error] = "Waa waa no invoice for you"
      redirect_to edit_itinerary_price_path(@itinerary_price)
    else
      flash[:success] = "Invoices smashed it"
      redirect_to edit_itinerary_price_path(@itinerary_price)
    end 
    
  end
  
private
  def itinerary_price_params
    params.require(:itinerary_price).permit(:itinerary_id, :deposit_due,
    :invoice_date, :balance_due, :final_balance_due, :currency_id,
    :deposit, :sale_total, :deposit_system_default, :booking_confirmed, :booking_confirmed_date, 
    itinerary_price_items_attributes: [:id, :booking_ref, :description,
    :price_total,  :deposit, :deposit_percentage,
    :item_price, :quantity, :start_date, :end_date, :_destroy ],
    supplier_itinerary_price_items_attributes: [:id, :exchange_rate_total, :booking_ref, :description,
    :price_total, :itinerary_price_id, :supplier_id, :markup, :markup_percentage,
    :item_price, :quantity, :currency_id, :sell_currency_rate, :total_incl_markup,  :_destroy ])
  end
end