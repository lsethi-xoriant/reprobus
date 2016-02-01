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
    set_email_modal_values_supplier_documents
  end
  
  def create
    @itinerary_price = ItineraryPrice.new(itinerary_price_params)
    @itinerary = @itinerary_price.itinerary
    
    if @itinerary_price.save
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
      if !request.xhr?
        flash[:success] = "Itinerary Pricing updated"
        redirect_to edit_itinerary_price_path(@itinerary_price) 
      else
        render :json => { :success => true }
      end
    else
      if !request.xhr?
        render 'edit'
      else
        render :json => { :success => false }
      end
    end
  end

  def invoice
    @itinerary_price = ItineraryPrice.find(params[:id])
    @itinerary = @itinerary_price.itinerary
    
    if !@itinerary_price.has_uninvoiced_customer_items
      flash[:error] = "No items requiring invoices!"
      return redirect_to edit_itinerary_price_path(@itinerary_price)
    end
    
    errorMsgs = @itinerary_price.create_customer_invoices(current_user) 
    
    if errorMsgs.empty?
      flash[:success] = "Invoice created"
      redirect_to edit_itinerary_price_path(@itinerary_price)
    else
      errorMsgs.each do |errorStr|
        flash[:error] = "Error creating invoice"
      end 
      redirect_to edit_itinerary_price_path(@itinerary_price)
    end 
  end
  
  def invoice_supplier
    @itinerary_price = ItineraryPrice.find(params[:id])
    @itinerary = @itinerary_price.itinerary
    
    if !@itinerary_price.has_uninvoiced_supplier_items
      flash[:error] = "No items requiring invoices!"
      return redirect_to edit_itinerary_price_path(@itinerary_price)
    end
    
    errorMsgs = @itinerary_price.create_supplier_invoices(current_user) 
      
    if errorMsgs.empty?  
      flash[:success] = "Invoice created"
      redirect_to edit_itinerary_price_path(@itinerary_price)
    else
      errorMsgs.each do |errorStr|
        flash[:error] = errorStr
      end
      redirect_to edit_itinerary_price_path(@itinerary_price)
    end 
  end
  
  def invoice_details
    @itinerary_price = ItineraryPrice.find(params[:id])
    @itinerary = @itinerary_price.itinerary
    @invoices =  @itinerary_price.invoices
  end
  
  def supplier_invoice_details
    @itinerary_price = ItineraryPrice.find(params[:id])
    @itinerary = @itinerary_price.itinerary
    @invoices =  @itinerary_price.supplier_invoices
    render "invoice_details"
  end
  
  def invoice_remaining
    @itinerary_price = ItineraryPrice.find(params[:id])
    @itinerary = @itinerary_price.itinerary
    @xinvoices = []
    @invoices =[]
    
    @itinerary_price.itinerary_price_items.each do |ipi|
      @xinvoices << ipi.invoice.x_invoice if ipi.invoice
      @invoices << ipi.invoice if ipi.invoice
    end
    
    respond_to do |format|
      format.pdf do
        render :pdf => "invoice_no_ " + @itinerary.id.to_s.rjust(8, '0') + "_balance"
      end
    end
  end

  def invoice_deposit
    @itinerary_price = ItineraryPrice.find(params[:id])
    @itinerary = @itinerary_price.itinerary
    @xinvoices = []
    @invoices =[]
    
    @itinerary_price.itinerary_price_items.each do |ipi|
      if ipi.invoice && ipi.invoice.x_invoice
        @xinvoices << ipi.invoice.x_invoice 
        @invoices << ipi.invoice 
      end
    end
    
    respond_to do |format|
      format.pdf do
        render :pdf => "invoice_no_ " + @itinerary.id.to_s.rjust(8, '0') + "_deposit"
      end
    end
  end
  
  def invoice_supplier_pdf
    @supplier_itinerary_price_item = ItineraryPriceItem.find(params[:id])
    @supplier_itinerary_price = @supplier_itinerary_price_item
    @itinerary = @supplier_itinerary_price.itinerary
    @invoice = @supplier_itinerary_price.invoice 
    @xinvoice = @invoice.x_invoice
    
    respond_to do |format|
      format.pdf do
        render :pdf => "invoice_no_ " + @itinerary.id.to_s.rjust(8, '0') + "_deposit"
      end
    end
  end  
  
  def invoice_deposit_old
   @itinerary_price = ItineraryPrice.find(params[:id])
    @itinerary = @itinerary_price.itinerary
    @xinvoices = []
    @invoices =[]
    
    @itinerary_price.itinerary_price_items.each do |ipi|
      if ipi.invoice && ipi.invoice.x_invoice
        @xinvoices << ipi.invoice.x_invoice 
        @invoices << ipi.invoice 
      end
    end
    
    respond_to do |format|
      format.pdf do
        render :pdf => "invoice_no_ " + @itinerary.id.to_s.rjust(8, '0') + "_deposit"
      end
    end
  end  

  def printQuote
    @itinerary_price_item = ItineraryPriceItem.find(params[:itinerary_price_item_id])
    @itinerary_price = ItineraryPrice.find(@itinerary_price_item.supplier_itinerary_price_id)
    @itinerary = @itinerary_price.try(:itinerary)
    @supplier = @itinerary_price_item.supplier
    @itinerary_infos = @itinerary
                        .itinerary_infos
                        .select { |info| info.supplier_id == @supplier.id }

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
    @itinerary_price_item = ItineraryPriceItem.find(params[:itinerary_price_item_id])
    @itinerary_price = ItineraryPrice.find(@itinerary_price_item.supplier_itinerary_price_id)
    @itinerary = @itinerary_price.try(:itinerary)
    @supplier = @itinerary_price_item.supplier
    @itinerary_infos = @itinerary
                        .itinerary_infos
                        .select { |info| info.supplier_id == @supplier.id }
    confirmed = params[:confirmed].presence ? ActiveRecord::Type::Boolean.new.type_cast_from_user(params[:confirmed]) : false
    check = params[:check].presence ? ActiveRecord::Type::Boolean.new.type_cast_from_user(params[:check]) : false

    if CustomerMailer.send_email_supplier_quote(
      @itinerary, @itinerary_price, @itinerary_price_item, @itinerary_infos, 
      @supplier, confirmed, check, params[:email_settings]).deliver_later

      confirmed_name = confirmed ? 'Confirmed' : ''
      flash[:success] = "#{confirmed_name} Supplier Quote has been sent."
    else
      flash[:error] = 'Error occured while sending Quote'
    end

    redirect_to edit_itinerary_price_path(@itinerary_price)
  end

  def emailQuote_bulk
    @itinerary = Itinerary.find(params[:itinerary_id])
    @itinerary_price = @itinerary.itinerary_price
    confirmed = params[:confirmed].presence ? ActiveRecord::Type::Boolean.new.type_cast_from_user(params[:confirmed]) : false
    check = params[:check].presence ? ActiveRecord::Type::Boolean.new.type_cast_from_user(params[:check]) : false

    @itinerary_price_item_ids = params[:itinerary_price_item_ids]
                                  .split(",")
                                  .map(&:to_i)
                                  .uniq
    @itinerary_price_items = ItineraryPriceItem.includes(:supplier).where(id: @itinerary_price_item_ids)

    @itinerary_price_items.each do |item|
      @supplier = item.supplier
      @itinerary_infos = @itinerary
                          .itinerary_infos
                          .select { |info| info.supplier_id == @supplier.id }

      CustomerMailer.send_email_supplier_quote(
        @itinerary, @itinerary_price, item, @itinerary_infos, @supplier, confirmed, check, params[:email_settings]).deliver_later
    end

    flash[:success] = "Emails has been sent."

    redirect_to edit_itinerary_path(params[:itinerary_id])
  end
  
private
  def set_email_modal_values_supplier_documents
      @from_email = 
      @setting.try(:itineraries_from_email).presence || User.find_by_name("System").try(:email)
      @cc_email = current_user.try(:email)
  end

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
