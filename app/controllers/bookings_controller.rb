class BookingsController < ApplicationController
   before_filter :signed_in_user
   before_filter :admin_user, only: :destroy
  
  
  def addxeroinvoice
    @booking = Booking.find(params[:id])
    if @booking.create_invoice_xero(current_user) 
      redirect_to @booking
    else
      render "show"
    end
  end
  
  def getxeroinvoice
    @booking = Booking.find(params[:id])
    @invoice = @booking.get_invoice_xero()
    respond_to do |format|
        format.js
    end
  end
  
  def addxeropayment
    @booking = Booking.find(params[:id])
    if params[:amount].nil? || !is_number?(params[:amount])  
      flash[:warning] = "Payment amount must be entered. You entered #{params[:amount]}"
      redirect_to @booking  
    else
    @booking.add_xero_payment(params[:amount])
      flash[:success] = "Payment added succesfully ($#{params[:amount]})"
      redirect_to @booking
    end
  end

  def index
    @bookings = Booking.paginate(page: params[:page])
  end
  
  def new
    @booking = Booking.new
  end

  def show
    @booking = Booking.find(params[:id])
    #@activities = @booking.activities.order('created_at DESC').page(params[:page]).per_page(5)
    respond_to do |format|
      format.html
      format.json { render json: {name: @booking.fullname, id: @booking.id  }}
    end    
  end
  
  def edit
    @booking = Booking.find(params[:id])
  end
  
  def create
    @booking = Booking.new(booking_params)
    #@customer.emailID = SecureRandom.urlsafe_base64
    if @booking.save
      flash[:success] = "Booking created!"
      redirect_to @booking
    else
      render 'new'
    end
  end  

  def update
     @booking = Booking.find(params[:id])
    if @booking.update_attributes(booking_params)
      flash[:success] = "Booking updated"
      redirect_to @booking
    else
      render 'edit'
    end
  end
private
    def booking_params
      params.require(:booking).permit(:name, :amount, :deposit, :status)      
    end  
end