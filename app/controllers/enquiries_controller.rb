class EnquiriesController < ApplicationController
  authorize_resource class: EnquiriesController, :except => [:webenquiry, :confirmation]
  
  before_filter :signed_in_user
  # before_filter :admin_user, only: :destroy
  skip_before_filter :verify_authenticity_token, only: [:webenquiry, :confirmation]
  skip_before_filter :signed_in_user, only: [:webenquiry, :confirmation]
  layout "plain", only: [:webenquiry, :confirmation]
  
  @pageName = "Enquiry"
  
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
    #@enquiries = Enquiry.includes(:customers).active.page(params[:page])
    respond_to do |format|
      format.html
      format.json { render json: EnquiryDatatable.new(view_context, { user: current_user }) }
    end
  end
  
  def new
    @enquiry = Enquiry.new
    if params[:customer_id]
      @customer = Customer.find(params[:customer_id])
      @enquiry.customers << @customer
    else
      @enquiry.customers.build
      @enquiry.customers.first.build_address
    end
    @enquiry.stage = "New Enquiry"
    @enquiry.assignee = current_user
    @enquiry.lead_customer = @enquiry.customers.first
    @enquiry.customers.first.lead_customer = true
  end

  def show
    @enquiry = Enquiry.find(params[:id])
    @activities = @enquiry.activities.order('created_at DESC').page(params[:page]).per(20)
  end

  def edit
    @enquiry = Enquiry.find(params[:id])
    @customer = @enquiry.lead_customer
    @hasActivities = !@enquiry.activities.empty?
    @enquiry.activities.build
    @activities = @enquiry.activities.order('created_at DESC').page(params[:page]).per(20)
  end
  
  def create
    @enquiry = Enquiry.new()

    params[:enquiry][:customers_attributes].each do |key, value|
      if !value[:id].to_s.blank? #existing customer
        @customer = Customer.find(value[:id])
        @enquiry.customers << @customer
      end
    end
    
    @enquiry.assign_attributes(enquiry_params);

    if @enquiry.save
      Trigger.trigger_new_enquiry(@enquiry)
      flash[:success] = "Enquiry Created!  #{undo_link}"
      redirect_to edit_enquiry_path(@enquiry)
    else
      render 'new'
    end
  end
  
  def update
    @enquiry = Enquiry.find(params[:id])
    
    # if we have added existing customers through search, need to add them to relationship otherwise
    # rails will throw error as relationship does not exist.
    params[:enquiry][:customers_attributes].each do |key, value|
      if !value[:id].to_s.blank? #existing customer
        @customer = Customer.find(value[:id])
        @enquiry.customers << @customer unless @enquiry.customers.include?(@customer)
      end
    end

    @enquiry.assignee = User.find(params[:assigned_to]) if params[:assigned_to].to_i > 0

    # on enquiry edit we are building a activity so to provide a note if one is entered. if there is no note, delete the build so we dont get a validation error or an empty note...
    if params[:enquiry][:activities_attributes]["0"][:description] == "" 
      params[:enquiry].delete(:activities_attributes)
    end

    if @enquiry.update_attributes(enquiry_params)
    
      undo_link = view_context.link_to("(Undo)",
      revert_version_path(@enquiry.versions.last), :method => :post)
      
      flash[:success] = "Enquiry updated.  #{undo_link}"
      
      if @enquiry.itineraries.any?
        redirect_to edit_itinerary_path(@enquiry.itineraries.first)
      else
        redirect_to edit_enquiry_path(@enquiry)
      end
    else
      flash[:error] = "Validation errors"
      render 'edit'
    end
  end
  
  def webenquiry
    ###### SHOULD HAVE SOME VERIFICATION HERE TO CHECK SITES ACCESSING THIS ARE ALLOWED (maybe hidden field in enquiry form plug in?)
    @enquiry = Enquiry.new()
    @enquiry.name = "Web Enq - " + params[:firstname] + " " + params[:surname]
    @enquiry.source = "Web"
    @enquiry.stage = "New Enquiry"
    @enquiry.user_id = User.find_by_name("System").id
    @enquiry.background_info = params[:enquiry_detail]
    @cust = Customer.find_by_email(params[:email]) unless params[:email].nil?
    if @cust.nil?
      @cust = Customer.new()
    end
    @cust.first_name = params[:firstname]
    @cust.last_name = params[:surname]
    @cust.email = params[:email]
    @cust.phone = params[:phone]
    
    @cust.save
    @enquiry.lead_customer = @cust
    
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
        :assigned_to, :num_people, :duration, :est_date, :percent, :campaign,
        :fin_date, :standard, :insurance, :reminder, :destination_id,
        customers_attributes: [:id, :first_name, :last_name, :email, :phone, :alt_phone, :title, :lead_customer, :_destroy], 
        activities_attributes: [:id, :enquiry_id, :description, :type, :user_id, :_destroy] )
    end

    def undo_link
      view_context.link_to("(Undo)",
        revert_version_path(@enquiry.versions.last), :method => :post)
    end
end
