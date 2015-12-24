class CustomersController < ApplicationController
  authorize_resource class: CustomersController
  
  before_filter :signed_in_user, except: [:details, :update_details]
  # before_filter :admin_user, only: :destroy
  before_action :setCompanySettings
  layout "customer_details", :only => [ :details ]
  
  def index
#  @customers = Customer.where(cust_sup: "Customer")
   respond_to do |format|
      format.html
      format.json { render json: CustomerDatatable.new(view_context, { user: current_user }) }
    end
  end

  def new
    @customer = Customer.new
    @address = @customer.build_address
  end

  def show
    @customer = Customer.find(params[:id])
    @activities = @customer.activities.order('created_at DESC').page(params[:page]).per(5)
    respond_to do |format|
      format.html
      format.json { render json: {name: @customer.fullname, id: @customer.id  }}
    end
  end
  
  def edit
    @customer = Customer.find(params[:id])
    @activities = @customer.activities.order('created_at DESC').page(params[:page]).per(5)
  end

  def details
    @customer = Customer.find(params[:customer_id])
    if params[:auth_key] && params[:auth_key] == @customer.try(:public_edit_token) &&
                @customer.try(:public_edit_token_expiry).try(:to_date) > DateTime.now
      render '_form', locals: { buttontxt: "Update Details", update_action: "customer_update_details" }
    else
      redirect_to noaccess_path
    end
  end

  def update_details
    @customer = Customer.find(params[:customer_id])

    if params[:auth_key] && params[:auth_key] == @customer.try(:public_edit_token) &&
                @customer.try(:public_edit_token_expiry).try(:to_date) > DateTime.now
      if @customer.update_attributes(customer_params)
        flash[:success] = "Your profile was successfully updated."
      else
        flash[:error] = "Some problems occured while updating. Please, try again."
      end
      redirect_to customer_details_path @customer, auth_key: params[:auth_key]
    else
      redirect_to noaccess_path
    end
  end
  
  def create
    @customer = Customer.new(customer_params)
    #@customer.emailID = SecureRandom.urlsafe_base64
    
    if !customer_params.has_key?(:cust_sup)
      @customer.cust_sup = "Customer"
    end
    
    if @customer.save
      flash[:success] = "#{@customer.cust_sup} created!"
      if @customer.isSupplier?
        redirect_to edit_supplier_path @customer
      elsif @customer.isAgent?
       redirect_to edit_agent_path @customer
      else
        redirect_to edit_customer_path @customer
      end
    else
      render 'new'
    end
  end

  def update
     @customer = Customer.find(params[:id])

    if @customer.update_attributes(customer_params)
      flash[:success] = "#{@customer.cust_sup} updated"
      if @customer.isSupplier?
        redirect_to edit_supplier_path @customer
      elsif @customer.isAgent?
       redirect_to edit_agent_path @customer
      else
        redirect_to edit_customer_path @customer
      end
    else
      render 'edit'
    end
  end

  def addnote
    @customer = Customer.find(params[:id])
    act = @customer.activities.create(type: params[:type], description: params[:note])
    
    if act
      current_user.activities<<(act)
      flash[:success] = "Note added"
    end
    redirect_to @customer
  end

  def destroy
    @customer = Customer.find(params[:id]).destroy
    flash[:success] = "#{@customer.cust_sup} deleted."
    
    if @customer.isSupplier?
      redirect_to suppliers_url
    elsif @customer.isAgent?
     redirect_to agents_url
    else
      redirect_to customers_url
    end    
  end
  
private
    def customer_params
      params.require(:customer).permit(:last_name, :first_name, :title, :cust_sup, :num_days_payment_due,
        :source, :email, :alt_email, :phone, :mobile, :issue_date, :expiry_date, :currency_id, :agent_commision_percentage,
        :place_of_issue, :passport_num, :insurance, :gender, :born_on, :supplier_name, :after_hours_phone,
        :quote_introduction, :confirmed_introduction, :nationality,
        :medical_information, :dietary_requirements,
        :emergency_contact_phone, :emergency_contact, :frequent_flyer_details,
        trigger_attributes: [:email_template_id], company_logo_attributes: [:id, :image_local, :image_remote_url],
        address_attributes: [:street1, :street2, :city, :state, 
        :zipcode, :country, :full_address, :address_type, :addressable_type, :addressable_id])
    end
end
