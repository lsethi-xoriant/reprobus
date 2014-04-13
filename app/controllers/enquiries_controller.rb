class EnquiriesController < ApplicationController
  before_filter :signed_in_user,
                only: [:index, :edit, :update, :destroy]
  before_filter :admin_user, only: :destroy
  
  def index
    @enquiries = Enquiry.paginate(page: params[:page])
  end
  
  def new
    @enquiry = Enquiry.new
	@enquiry.customers.build
  end

  def show
    @enquiry = Enquiry.find(params[:id])
  end
  
  def edit
    @enquiry = Enquiry.find(params[:id])
  end
  
  def create
    @enquiry = Enquiry.new(enquiry_params)
    if @enquiry.save
      flash[:success] = "Enquiry Created!"
      redirect_to @enquiry
    else
      render 'new'	
    end
  end  

  def update
    @enquiry = Enquiry.find(params[:id])
    if @enquiry.update_attributes(enquiry_params)

#tidy up one day  - find better way to do this
    @enquiry.customers.clear
    params[:enquiry][:customer_ids].each do |cust| 
      @enquiry.add_customer(Customer.find(cust)) unless cust.blank?
      #puts cust
    end
    @enquiry.save
#end bad code
      
      flash[:success] = "Enquiry updated"
      redirect_to @enquiry
    else
      render 'edit'
    end
  end
  
private
    def enquiry_params
      params.require(:enquiry).permit(:name, :source, :stage,
        :probability, :amount, :discount, :closes_on, :background_info, :user_id, 
		:assigned_to, :num_people, :duration, :est_date, :percent )      
    end  
end
