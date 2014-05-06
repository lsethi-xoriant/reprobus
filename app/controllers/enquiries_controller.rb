class EnquiriesController < ApplicationController
  before_filter :signed_in_user,
                only: [:index, :edit, :update, :destroy, :new]
  before_filter :admin_user, only: :destroy

  def index
    @enquiries = Enquiry.paginate(page: params[:page])
  end
  
  def new
    
#    if session[:enquiry]
#      @enquiry = Enquiry.new(enquiry_params)
#      @enquiry.valid? # run validations to to populate the errors[]
# puts "HELLO HAMISH"     
#    else
      @enquiry = Enquiry.new
	    @enquiry.customers.build
      @enquiry.customers.first.build_address
#    end
    
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
    @enquiry.customers.clear if params[:existing_customer].to_i > 0 
    if @enquiry.save    
      @enquiry.add_customer(Customer.find(params[:existing_customer])) if params[:existing_customer].to_i > 0 
      flash[:success] = "Enquiry Created!  #{undo_link}"
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
      end
      #@enquiry.touch_with_version  #put this in so when just adding customers, papertrail is triggered. 
      @enquiry.save
#end bad code
      
      undo_link = view_context.link_to("(Undo)", 
        revert_version_path(@enquiry.versions.last), :method => :post)
      
      flash[:success] = "Enquiry updated.  #{undo_link}" 
      redirect_to @enquiry
    else
      render 'edit'
    end
  end

  def destroy 
    @enquiry = Enquiry.find(params[:id])
    @enquiry.destroy
    flash[:success] = "Enquiry deleted.  #{undo_link}"
    redirect_to enquiries_url
  end  

private
    def enquiry_params
      params.require(:enquiry).permit(:name, :source, :stage,
        :probability, :amount, :discount, :closes_on, :background_info, :user_id, 
        :assigned_to, :num_people, :duration, :est_date, :percent,  :existing_customer, 
        :fin_date, :standard, :destinations, :stopovers, :carriers, :insurance, :reminder,
        customers_attributes: [:first_name, :last_name, :email, :phone, :mobile, :title] )      
    end  

    def undo_link
      view_context.link_to("(Undo)",  
        revert_version_path(@enquiry.versions.scoped.last), :method => :post)
    end
end
