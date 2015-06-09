class CustomersController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user, only: :destroy
  
  def index
    @customers = Customer.where(cust_sup: "Customer")
   respond_to do |format|
      format.html
      format.json { render json: CustomerDatatable.new(view_context, { user: current_user }) }
    end
  end
  
  
  def indextable
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
    @activities = @customer.activities.order('created_at DESC').page(params[:page]).per_page(5)
    respond_to do |format|
      format.html
      format.json { render json: {name: @customer.fullname, id: @customer.id  }}
    end
  end
  
  def edit
    @customer = Customer.find(params[:id])
    @activities = @customer.activities.order('created_at DESC').page(params[:page]).per_page(5)
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
        redirect_to supplier_path @customer
      elsif @customer.isAgent?
       redirect_to agent_path @customer
      else
        redirect_to @customer
      end
    else
      render 'new'
    end
  end

  def update
     @customer = Customer.find(params[:id])

    if @customer.update_attributes(customer_params)
      flash[:success] = "Customer updated"
      if @customer.isSupplier?
        redirect_to supplier_path @customer
      elsif @customer.isAgent?
       redirect_to agent_path @customer
      else
        redirect_to @customer
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
    Customer.find(params[:id]).destroy
    flash[:success] = "Customer deleted."
    redirect_to customers_url
  end
  
private
    def customer_params
      params.require(:customer).permit(:last_name, :first_name, :title, :cust_sup, :num_days_payment_due,
        :source, :email, :alt_email, :phone, :mobile, :issue_date, :expiry_date, :currency_id,
        :place_of_issue, :passport_num, :insurance, :gender, :born_on, :supplier_name, :after_hours_phone,
        trigger_attributes: [:email_template_id])
    end
end
