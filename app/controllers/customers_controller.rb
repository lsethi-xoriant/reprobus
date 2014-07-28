class CustomersController < ApplicationController
  before_filter :signed_in_user,
                only: [:index, :edit, :update, :destroy, :new, :show, :create]
  before_filter :admin_user, only: :destroy
  
  def index
    @customers = Customer.paginate(page: params[:page])
  end
  
  def new
    @customer = Customer.new
    @address = @customer.build_address
  end

  def show
    @customer = Customer.find(params[:id])
  end
  
  def edit
    @customer = Customer.find(params[:id])
  end
  
  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      flash[:success] = "Customer created!"
      redirect_to @customer
    else
      render 'new'
    end
  end  

  def update
     @customer = Customer.find(params[:id])
    if @customer.update_attributes(customer_params)
      flash[:success] = "Customer updated"
      redirect_to @customer
    else
      render 'edit'
    end
  end

  def addnote
    @customer = Customer.find(params[:id])
  
    if @customer.activities.create(type: params[:type], description: params[:note])
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
      params.require(:customer).permit(:last_name, :first_name, :title,
        :source, :email, :alt_email, :phone, :mobile, :issue_date, :expiry_date, 
        :place_of_issue, :passport_num, :insurance, :gender, :born_on,
        address_attributes: [:street1, :street2, :city, :state, :zipcode, :country])      
    end  
end
