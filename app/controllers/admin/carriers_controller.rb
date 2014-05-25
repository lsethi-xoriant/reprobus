class Admin::CarriersController < ApplicationController
  before_filter :admin_user
  
  def index
    @carriers = Carrier.paginate(page: params[:page])
  end
  def new
    @carrier = Carrier.new
  end

  def edit
    @carrier = Carrier.find(params[:id])
  end
  
  def show
    @carrier = Carrier.find(params[:id])
  end
  
  def create
    @carrier = Carrier.new(carrier_params)
    if @carrier.save
      flash[:success] = "Carrier created!"
      redirect_to admin_carrier_path(@carrier)
    else
      render 'new'
    end
  end  

  def destroy
    Carrier.find(params[:id]).destroy
    flash[:success] = "Carrier deleted."
    redirect_to admin_carriers_path 
  end  
  
  def update
     @carrier = Carrier.find(params[:id])
    if @carrier.update_attributes(carrier_params)
      flash[:success] = "Carrier updated"
      redirect_to @carrier
    else
      render 'edit'
    end
  end
  
private
    def carrier_params
      params.require(:carrier).permit(:name)
    end  
  
end