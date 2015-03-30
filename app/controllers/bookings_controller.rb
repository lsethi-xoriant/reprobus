class BookingsController < ApplicationController
   before_filter :signed_in_user
   before_filter :admin_user, only: :destroy


  def index
    @bookings = Booking.includes(:customer).paginate(page: params[:page])
  end
  
  def new
    @booking = Booking.new
  end

  def show
    @booking = Booking.find(params[:id])
    @setting = Setting.find(1)
    @enquiry = @booking.enquiry
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
      params.require(:booking).permit(:name, :amount, :deposit, :status, :user_id)
    end
end