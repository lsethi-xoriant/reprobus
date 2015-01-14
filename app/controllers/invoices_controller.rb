class InvoicesController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user, only: :destroy
  
 def index
   @invoices = Invoice.paginate(page: params[:page])
  end
  
  def new
    @invoice = Invoice.new
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
    while i < 10 
puts "HAMISH " +  "desc"+i.to_s 
      item = params["desc"+i.to_s]
      
      if item.blank? 
        puts "HAMISH " +  "breaking as item is blank  " +  "desc"+i.to_s 
        break
      end
puts "HAMISH " +  "creating line item = " + item
      
     # if params["price"+i.to_s].blank? || params["qty"+i.to_s].blank? 
     #   err = "Line item " + (i+1).to_s + " not complete. All fields must be completed" 
     #   puts "HAMISH " +  "breaking as one of the values in item is blank "  +  "desc"+i.to_s + " price =  " + params["price"+i.to_s] +  " qty =  " + params["qty"+i.to_s] 
     #   break
     # end
      total = (params["price"+i.to_s].to_i *  params["qty"+i.to_s].to_i)
      inv.line_items.build(description: params["desc"+i.to_s], item_price: params["price"+i.to_s], quantity: params["qty"+i.to_s], total: total)    
      i+=1
      
      puts "HAMISH " +  " line item created "+i.to_s 
      
      if 1 > 9999
        puts "HAMISH WE HAVE A PROBLEM INVOICES CONTROLLER LINE 37ISH"
        break   #failsafe...
      end
    end

    @invoice = inv
    #@invoice.emailID = SecureRandom.urlsafe_base64
    if @invoice.save #&& err.blank?
      flash[:success] = "Invoice created!"
      redirect_to booking_invoice_path( @booking, @invoice)
    else
      #if !err.blank?
      #  flash[:warning] = err
      #end
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
  