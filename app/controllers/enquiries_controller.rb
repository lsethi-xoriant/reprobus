class EnquiriesController < ApplicationController
  before_filter :signed_in_user,
                only: [:index, :edit, :update, :destroy, :new, :show, :create, :customersearch, :carriersearch]
  before_filter :admin_user, only: :destroy
  
  def index
    @enquiries = Enquiry.paginate(page: params[:page])
  end
  
  def new
      @enquiry = Enquiry.new
	    @enquiry.customers.build
      @enquiry.customers.first.build_address
  end

  def show
    @enquiry = Enquiry.find(params[:id])
  end

  def edit
    @enquiry = Enquiry.find(params[:id])
  end
  
  def create
    @enquiry = Enquiry.new(enquiry_params)     
    @enquiry.assignee = User.find(params[:assigned_to]) if params[:assigned_to].to_i > 0  #refactor
    
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
    if params[:existing_customer].to_i > 0 
      params[:enquiry].delete(:customers_attributes)
    end
    
    @enquiry = Enquiry.find(params[:id])
    @enquiry.assignee = User.find(params[:assigned_to]) if params[:assigned_to].to_i > 0  #refactor

    if @enquiry.update_attributes(enquiry_params)
#tidy up one day  - find better way to do this
      @enquiry.customers.clear
      
      if params[:existing_customer].to_i > 0 
        @enquiry.add_customer(Customer.find(params[:existing_customer]))
      elsif !params[:enquiry][:customer_ids].nil?
        params[:enquiry][:customer_ids].each do |cust| 
          @enquiry.add_customer(Customer.find(cust)) unless cust.blank?
        end
      end
      
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

  def numericID?(str)
    Float(str) != nil rescue false
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

  def carriersearch
    @entities = Carrier.select([:id, :name]).
                            where("name ILIKE :q", q: "%#{params[:q]}%").
                            order('name')
  
    # also add the total count to enable infinite scrolling
    resources_count = Carrier.select([:id, :name]).
      where("name ILIKE :q", q: "%#{params[:q]}%").count

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
    resources_count = Stopover.select([:id, :name]).
      where("name ILIKE :q", q: "%#{params[:q]}%").count

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
    resources_count = Destination.select([:id, :name]).
           where("name ILIKE :q", q: "%#{params[:q]}%").count

    respond_to do |format|
      format.json { render json: {total: resources_count, 
                    searchSet: @entities.map { |e| {id: e.id, text: "#{e.name}"} }} }
    end
  end

private
    def enquiry_params
      params.require(:enquiry).permit(:name, :source, :stage,
        :probability, :amount, :discount, :closes_on, :background_info, :user_id, 
        :assigned_to, :num_people, :duration, :est_date, :percent,  :existing_customer, 
        :fin_date, :standard, :insurance, :reminder,
        customers_attributes: [:first_name, :last_name, :email, :phone, :mobile, :title] )      
    end  

    def undo_link
      view_context.link_to("(Undo)",  
        revert_version_path(@enquiry.versions.scoped.last), :method => :post)
    end
end
