class CustomersController < ApplicationController
  before_filter :signed_in_user,
                only: [:index, :edit, :update, :destroy]
  before_filter :admin_user, only: :destroy
  
  def index
    @customers = Customer.paginate(page: params[:page])
  end
  
  def new
    @customer = Customer.new
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
      flash[:success] = "customer Created!"
      redirect_to @customer
    else
      render 'new'
    end
  end  

  def update
     @customer = Customer.find(params[:id])
    if @customer.update_attributes(customer_params)
      flash[:success] = "customer updated"
      redirect_to @customer
    else
      render 'edit'
    end
  end
  
private
    def customer_params
      params.require(:customer).permit(:last_name, :first_name, :title,
                                   :source, :email, :alt_email, :phone, :mobile)      
    end  
end
