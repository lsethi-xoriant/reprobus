class InvoicesController < ApplicationController
  before_filter :signed_in_user, :except => [:pxpaymentsuccess, :pxpaymentfailure]
  before_filter :admin_user, only: :destroy
  layout 'plain', :only => [:pxpaymentsuccess, :pxpaymentfailure]
  
  
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
   @invoices = Invoice.paginate(page: params[:page])
  end
  
  def new
    @invoice = Invoice.new
    @booking = Booking.find(params[:booking_id])
  end

  def show
    @invoice = Invoice.find(params[:id])
    @booking = @invoice.booking
    respond_to do |format|
      format.html
      #format.json { render json: {name: @invoice.fullname, id: @invoice.id  }}
      format.pdf do
        render :pdf => "invoice_no_ " + @invoice.id.to_s.rjust(8, '0')
      end
    end    
  end
  
  def edit
    @invoice = Invoice.find(params[:id])
  end
  
  def create
    @booking = Booking.find(params[:booking_id])
    inv = @booking.build_invoice(status: "New", invoice_date: Date.today, final_payment_due: params[:final_payment_due], deposit_due: params[:deposit_due], deposit: params[:deposit])
    
    i = 0;
    while i < 9999 
      if !params.has_key?("desc"+i.to_s)
        break
      end
      
      total = (params["price"+i.to_s].to_i *  params["qty"+i.to_s].to_i)
      inv.line_items.build(description: params["desc"+i.to_s], item_price: params["price"+i.to_s], quantity: params["qty"+i.to_s], total: total)    
      i+=1
    end

    @invoice = inv
    
    if @invoice.save #&& err.blank? 
      if Setting.find(1).use_xero 
        err = @booking.create_invoice_xero(current_user)
        if !err
          flash[:warning] = "Warning: Xero Invoice could not be created"
        end
      end     
      @booking.update_attribute(:status, "Invoice created")
      @booking.update_attribute(:amount, @invoice.getTotalAmount)
      flash[:success] = "Invoice created!"
      redirect_to booking_invoice_path( @booking, @invoice)
    else
      render 'new'
    end
  end  

  def update
     @invoice = Customer.find(params[:id])
    if @invoice.update_attributes(invoice_params)
      flash[:success] = "Customer updated"
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
    params.permit(:invoice_date, :deposit_due, :final_payment_due, :deposit,
        line_item_attributes: [:item_price, :total, :description, :quantity] )      
    end  
end
  