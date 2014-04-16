class EnquiriesController < ApplicationController
  before_filter :signed_in_user,
                only: [:index, :edit, :update, :destroy, :new]
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
  

  def customersearch
    @customers = Customer.select([:id, :last_name, :first_name]).
                            where("last_name ILIKE :q OR first_name ILIKE :q", q: "%#{params[:q]}%").
                            order('last_name')
  
    # also add the total count to enable infinite scrolling
    resources_count = Customer.select([:id, :last_name, :first_name]).
      where("last_name ILIKE :q  OR first_name ILIKE :q", q: "%#{params[:q]}%").count

    respond_to do |format|
      format.json { render json: {total: resources_count, 
                    searchSet: @customers.map { |e| {id: e.id, text: "#{e.first_name} #{e.last_name}"} }} }
    end
  end
    
  def edit
    @enquiry = Enquiry.find(params[:id])
  end
  
  def create
    @enquiry = Enquiry.new(enquiry_params)     
    if @enquiry.save
      if params[:existing_customer].to_i > 0 
        @enquiry.customers.clear
        @enquiry.add_customer(Customer.find(params[:existing_customer])) 
      end
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
        :assigned_to, :num_people, :duration, :est_date, :percent,  :existing_customer,
        customers_attributes: [:first_name, :last_name, :email, :phone, :title] )      
    end  
end
