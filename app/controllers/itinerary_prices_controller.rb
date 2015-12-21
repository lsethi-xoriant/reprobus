class ItineraryPricesController < ApplicationController
  authorize_resource class: ItineraryPricesController

  before_filter :signed_in_user
  # before_filter :admin_user, only: :destroy
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

  def printQuote
    @itinerary_price_item = ItineraryPriceItem.includes(:itinerary_price).find(params[:itinerary_price_item_id])
    @itinerary_price = ItineraryPrice.includes(:itinerary).find(params[:itinerary_price_id])
    @itinerary = @itinerary_price.try(:itinerary)
    @supplier = Customer.find(params[:supplier_id])
    @itinerary_infos = @itinerary
                        .itinerary_infos
                        .select { |info| info.supplier_id == @supplier.id } if @itinerary

    respond_to do |format|
      format.pdf do
        render  pdf: "Supplier_no_" + @itinerary.id.to_s.rjust(8, '0'),
                show_as_html: params.key?('debug'),
                margin: { bottom: 15 }
      end
      format.html { render layout: false }
    end    
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
  
private
  def itinerary_price_params
    params.require(:itinerary_price).permit(:itinerary_id, :deposit_due,
    :invoice_date, :balance_due, :final_balance_due, :currency_id, :customer_invoice_sent, :customer_invoice_sent_date,
    :deposit, :sale_total, :deposit_system_default, :booking_confirmed, :booking_confirmed_date, 
    itinerary_price_items_attributes: [:id, :booking_ref, :description,
    :price_total,  :deposit, :deposit_percentage,
    :item_price, :quantity, :start_date, :end_date, :_destroy ],
    supplier_itinerary_price_items_attributes: [:id, :exchange_rate_total, :booking_ref, :description,
    :price_total, :itinerary_price_id, :supplier_id, :markup, :markup_percentage,
    :item_price, :quantity, :currency_id, :sell_currency_rate, :total_incl_markup,  :_destroy ])
  end
end
