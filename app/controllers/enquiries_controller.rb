class EnquiriesController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user, only: :destroy
  skip_before_filter :verify_authenticity_token, only: [:webenquiry, :confirmation]
  skip_before_filter :signed_in_user, only: [:webenquiry, :confirmation]
  layout "plain", only: [:webenquiry, :confirmation]
  
  @pageName = "Enquiry"
  
  def addbooking
    @enquiry = Enquiry.find(params[:id])
    ## move these condtions to a validation.... so they all pop up if they are not meet, rather than the first one.

    if @enquiry.customers.blank? || @enquiry.customers.count == 0
      flash[:warning] = "Must have a customer when converting to a Booking."
      redirect_to @enquiry
    elsif @enquiry.est_date.blank? || @enquiry.fin_date.blank?
      flash[:warning] = "Start and finish date must be set before converting to booking."
      redirect_to @enquiry
    elsif !@enquiry.booking.nil?
      flash[:warning] = "Enquiry previously converted to Booking. <a href='" + booking_path(@enquiry.booking) +"'>Show Booking</a>"
      redirect_to @enquiry
    else
      if @enquiry.convert_to_booking!(current_user)
        flash[:success] = "Converted to booking"
        redirect_to @enquiry.booking
      else
        render 'show'
      end
    end
  end
  
  def addnote
    @enquiry = Enquiry.find(params[:id])
    act = @enquiry.activities.create(type: params[:type], description: params[:note])
    
    if act
      current_user.activities<<(act)
      flash[:success] = "Note added"
    end
    redirect_to @enquiry
  end
  
  def index
    @enquiries = Enquiry.includes(:customers).active.paginate(page: params[:page])
  end
  
  def index_bookings
    @bookings = Enquiry.bookings.paginate(page: params[:page])
  end
  
  def new
    @enquiry = Enquiry.new
	  @enquiry.customers.build
    @enquiry.customers.first.build_address
    @customer = @enquiry.customers.first
    @enquiry.stage = "New Enquiry"
    @enquiry.assignee = current_user
  end

  def show
    @enquiry = Enquiry.find(params[:id])
    @activities = @enquiry.activities.order('created_at DESC').page(params[:page]).per_page(5)
  end

  def edit
    @enquiry = Enquiry.find(params[:id])
    @customer = @enquiry.customers.first
  end
  
  def edit_booking
    @booking = Enquiry.find(params[:id])
  end
  
  def create
    @enquiry = Enquiry.new(enquiry_params)
    
    
    @enquiry.save

    #@enquiry.assignee = User.find(params[:assigned_to]) if params[:assigned_to].to_i > 0  #refactor
    
    if @enquiry.save
    #if @enquiry.update_attributes(enquiry_params)
      Trigger.trigger_new_enquiry(@enquiry)
      flash[:success] = "Enquiry Created!  #{undo_link}"
      redirect_to edit_enquiry_path(@enquiry)
    else
      render 'new'
    end
  end
  
  def update
    @enquiry = Enquiry.find(params[:id])
    if params[:search_cust_id]
      params[:search_cust_id].split(",").each do |custid|
        @customer = Customer.find(custid)
        @enquiry.customers << @customer
      end
    end
          
    @enquiry.assignee = User.find(params[:assigned_to]) if params[:assigned_to].to_i > 0
  
    if @enquiry.update_attributes(enquiry_params)
      
      # move these to nested form type arrangement - maybe with coocon?
      if params[:enquiry][:carriers] then
        @enquiry.carriers.clear
        params[:enquiry][:carriers].split(",").each do |id|
          if numericID?(id) then
            @enquiry.carriers << Carrier.find(id)
          end
        end
      end

      if params[:enquiry][:stopovers] then
        @enquiry.stopovers.clear
        params[:enquiry][:stopovers].split(",").each do |id|
          if numericID?(id) then
            @enquiry.stopovers << Stopover.find(id)
          end
        end
      end
        
      if params[:enquiry][:destinations] then
        @enquiry.destinations.clear
        params[:enquiry][:destinations].split(",").each do |id|
          if numericID?(id) then
            @enquiry.destinations << Destination.find(id)
          end
        end
      end
        
      #@enquiry.touch_with_version  #put this in so when just adding customers, papertrail is triggered.
      @enquiry.save
#end bad code
      
      undo_link = view_context.link_to("(Undo)",
      revert_version_path(@enquiry.versions.last), :method => :post)
      
      flash[:success] = "Enquiry updated.  #{undo_link}"
      redirect_to edit_enquiry_path(@enquiry)
    else
      render 'edit'
    end
  end
  
  def webenquiry
    ###### SHOULD HAVE SOME VERIFICATION HERE TO CHECK SITES ACCESSING THIS ARE ALLOWED (maybe hidden field in enquiry form plug in?)
    @enquiry = Enquiry.new()
    @enquiry.name = "Web Enq - " + params[:firstname] + " " + params[:surname]
    @enquiry.source = "Web"
    @enquiry.stage = "Open"
    @enquiry.user_id = User.find_by_name("System").id
    @enquiry.background_info = params[:enquiry_detail]
    @cust = Customer.find_by_email(params[:email]) unless params[:email].nil?
    if @cust.nil?
      @cust = Customer.new()
    end
    @cust.first_name = params[:firstname]
    @cust.last_name = params[:surname]
    @cust.email = params[:email]
    @cust.mobile = params[:phone]
    
    @cust.save
    
    if @enquiry.save
      @enquiry.add_customer(@cust)
      flash.now[:success] = "Thank you, enquiry submitted."
      render 'confirmation'
    end
    
  end
  
  def confirmation
    #stub... i think we need this here blank
  end

  def destroy
    @enquiry = Enquiry.find(params[:id])
    @enquiry.destroy
    flash[:success] = "Enquiry deleted.  #{undo_link}"
    redirect_to enquiries_url
  end

  def numericID?(str)
    Float(str) != nil rescue false
  end
        

  def carriersearch
    @entities = Carrier.select([:id, :name]).
                            where("name ILIKE :q", q: "%#{params[:q]}%").
                            order('name')
  
    # also add the total count to enable infinite scrolling
    resources_count = @entities.size

    respond_to do |format|
      format.json { render json: {total: resources_count,
                    searchSet: @entities.map { |e| {id: e.id, text: "#{e.name}"} }} }
    end
  end

  def stopoversearch
    @entities = Stopover.select([:id, :name]).
                            where("name ILIKE :q", q: "%#{params[:q]}%").
                            order('name')
  
    # also add the total count to enable infinite scrolling
    resources_count =  @entities.size

    respond_to do |format|
      format.json { render json: {total: resources_count,
                    searchSet: @entities.map { |e| {id: e.id, text: "#{e.name}"} }} }
    end
  end


  def destinationsearch
    @entities = Destination.select([:id, :name]).
                            where("name ILIKE :q", q: "%#{params[:q]}%").
                            order('name')
  
    # also add the total count to enable infinite scrolling
    resources_count =  @entities.size

    respond_to do |format|
      format.json { render json: {total: resources_count,
                    searchSet: @entities.map { |e| {id: e.id, text: "#{e.name}"} }} }
    end
  end

private
    def enquiry_params
      params.require(:enquiry).permit(:id, :name, :source, :stage, :agent_id,
        :probability, :amount, :discount, :closes_on, :background_info, :user_id,
        :assigned_to, :num_people, :duration, :est_date, :percent,  :existing_customer,
        :fin_date, :standard, :insurance, :reminder,
        customers_attributes: [:id, :first_name, :last_name, :email, :phone, :mobile, :title, :_destroy] )
    end

    def undo_link
      view_context.link_to("(Undo)",
        revert_version_path(@enquiry.versions.last), :method => :post)
    end
end