class InvoicesController < ApplicationController
  before_filter :signed_in_user, :except => [:pxpaymentsuccess, :pxpaymentfailure]
  before_filter :admin_user, only: :destroy
  layout 'plain', :only => [:pxpaymentsuccess, :pxpaymentfailure]

  def addxeroinvoice
    @invoice = Invoice.find(params[:id])
    if @invoice.create_invoice_xero(current_user) 
      redirect_to booking_invoice_path( @invoice.booking, @invoice)
    else
      render "show"
    end
  end
  
  def addxeropayment
    @invoice = Invoice.find(params[:id])
    if params[:amount].nil? || !is_number?(params[:amount])  
      flash[:danger] = "Payment amount must be entered. You entered #{params[:amount]}"
      redirect_to booking_invoice_path( @invoice.booking, @invoice)
    else
      @invoice.add_xero_payment(params[:amount])
      flash[:success] = "Payment added succesfully ($#{params[:amount]})"
      redirect_to booking_invoice_path( @invoice.booking, @invoice)
    end
  end

  def changexeroinvoice
    @invoice = Invoice.find(params[:id])
    if params[:amount].to_f < (params[:amount_total].to_f - params[:amount_due].to_f)
      flash[:danger] = "Payment amount cannot be less than amount paid. You entered #{params[:amount]}"
      redirect_to booking_invoice_path( @invoice.booking, @invoice)
    else
      @invoice.change_xero_invoice(params[:amount])
      flash[:success] = "Invoice updated succesfully ($#{params[:amount]})"
      redirect_to booking_invoice_path( @invoice.booking, @invoice)
    end
  end  

  def getxeroinvoice
    @invoice = Invoice.find(params[:id])
    @xinvoice = @invoice.get_invoice_xero()
    respond_to do |format|
        format.js
    end
  end

  def pxpaymentsuccess
    response = Pxpay::Response.new(params).response
    @hash = response.to_hash
    @invoice = Invoice.find(@hash[:txn_id])
    @booking = @invoice.booking
    @booking.update_attribute(:status, "Deposit Paid") 
    @invoice.addCCPayment!(@hash[:amount_settlement])
  end
  
  def pxpaymentfailure
      response = Pxpay::Response.new(params).response
      @hash = response.to_hash
  end
  
 def index
   @booking = Booking.find(params[:booking_id])
   @customer_invoices = @booking.customer_invoices.paginate(page: params[:page])
   @supplier_invoices = @booking.supplier_invoices.paginate(page: params[:page])
  end
  
  def new
    @invoice = Invoice.new
    @booking = Booking.find(params[:booking_id])
  end

  def supplierInvoice
    @invoice = Invoice.new
    @booking = Booking.find(params[:booking_id])
  end

  def show
    @invoice = Invoice.find(params[:id])
    @booking = Booking.find(params[:booking_id])
    respond_to do |format|
      format.html
      #format.json { render json: {name: @invoice.fullname, id: @invoice.id  }}
      format.pdf do
        render :pdf => "invoice_no_ " + @invoice.id.to_s.rjust(8, '0')
      end
    end    
  end
 
  def showSupplier
    @invoice = Invoice.find(params[:id])
    @booking = Booking.find(params[:booking_id])
  end

  def edit
    @invoice = Invoice.find(params[:id])
  end
  
  def create
    @booking = Booking.find(params[:booking_id])
    inv = @booking.customer_invoices.build(status: "New", invoice_date: Date.today, final_payment_due: params[:final_payment_due], 
      deposit_due: params[:deposit_due], deposit: params[:deposit], currency_id: params[:currency_id])
    inv.booking = @booking
    
    i = 0;
    while i < 999 
      if !params.has_key?("desc"+i.to_s)
        break
      end
      
      if params["desc"+i.to_s].blank? && params["price"+i.to_s].blank? && params["qty"+i.to_s].blank?
        i+=1
        next
      end
      
      total = (params["price"+i.to_s].to_i * params["qty"+i.to_s].to_i)
      inv.line_items.build(description: params["desc"+i.to_s], item_price: params["price"+i.to_s], quantity: params["qty"+i.to_s], total: total)    
      i+=1
    end
    
    inv.set_exchange_currency_amount
    @invoice = inv
    
    if @invoice.save #&& err.blank? 
      @booking.update_attribute(:amount, @invoice.getTotalAmount)
      if Setting.find(1).use_xero 
        err = @invoice.create_invoice_xero(current_user)
        if !err
          flash[:warning] = "Warning: Xero Invoice could not be created"
        end
      end     
      @booking.update_attribute(:status, "Invoice created")
      flash[:success] = "Invoice created!"
      redirect_to booking_invoice_path( @booking, @invoice)
    else
      render 'new'
    end
  end  

  def createSupplier
    @booking = Booking.find(params[:booking_id])
 
    #find appropriate currency
    if params[:currency_id].blank? # if overide not set then use suppier currency
      sup = Customer.find(params[:supplier_id]) if !params[:supplier_id].blank?
      if sup && !sup.currency.nil? 
        currID = sup.currency_id
      else # use system settings which defaults to AUD if nothing set
        currID = Setting.find(1).currencyID
      end
    else # use override
      currID = params[:currency_id]
    end
    
    inv = @booking.supplier_invoices.build(status: "New", invoice_date: Date.today, final_payment_due: params[:final_payment_due], 
      currency_id: currID, supplier_id: params[:supplier_id])
    inv.booking = @booking
    @invoice = inv
    
    i = 0;
    while i < 9999 
      if !params.has_key?("desc"+i.to_s)
        break
      end   
       
      if params["desc"+i.to_s].blank? && params["price"+i.to_s].blank? && params["qty"+i.to_s].blank?
        i+=1
        next
      end
      
      total = (params["price"+i.to_s].to_i *  params["qty"+i.to_s].to_i)
      inv.line_items.build(description: params["desc"+i.to_s], item_price: params["price"+i.to_s], quantity: params["qty"+i.to_s], total: total)    
      i+=1
    end

    inv.set_exchange_currency_amount
    
    if @invoice.save #&& err.blank? 
      if Setting.find(1).use_xero 
        err = @invoice.create_invoice_xero(current_user)
        if !err
          flash[:warning] = "Warning: Xero Invoice could not be created"
        end
      end     
      @booking.update_attribute(:status, "Invoice created")
      flash[:success] = "Invoice created!"
      redirect_to showSupplier_booking_invoices_path( @booking, @invoice)
    else
      render 'supplierInvoice'
    end
  end  

  def update
     @invoice = Customer.find(params[:id])
    if @invoice.update_attributes(invoice_params)
      flash[:success] = "Invoice updated"
      redirect_to @invoice
    else
      render 'edit'
    end
  end

  def destroy
    Invoice.find(params[:id]).destroy
    flash[:success] = "Invoice deleted."
    #redirect_to invoice
  end  
  
private
  def invoice_params
    params.permit(:invoice_date, :deposit_due, :final_payment_due, :deposit, :currency, :supplier_id, :currency_id,
        line_item_attributes: [:item_price, :total, :description, :quantity] )      
    end  
end
  