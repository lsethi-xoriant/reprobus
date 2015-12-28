class Admin::CarriersController < ApplicationController
  authorize_resource class: Admin::CarriersController
  # before_filter :admin_user
  
  def index
    @carriers = Carrier.all
    respond_to do |format|
      format.html
      format.csv { send_data @carriers.to_csv }
      format.xls
    end 
  end
  def new
    @carrier = Carrier.new
  end

  def edit
    @carrier = Carrier.find(params[:id])
  end
  
  def export
  end
  def import
  end  
  def importfile
    if !params[:file].nil? then 
      Carrier.import(params[:file])
      flash[:success] = "Carriers imported!"
      redirect_to admin_carriers_path
    else
      flash[:warning] = "No File!"
      redirect_to admin_carriers_import_path
    end
  end  
    
  def show
    @carrier = Carrier.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: {name: @carrier.name, id: @carrier.id  }}
    end   
  end
  
  def create
    @carrier = Carrier.new(carrier_params)
    if @carrier.save
      flash[:success] = "Carrier created!"
      redirect_to admin_carriers_path
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
      #redirect_to @carrier
      redirect_to admin_carriers_path 
    else
      render 'edit'
    end
  end
  
private
    def carrier_params
      params.require(:carrier).permit(:name)
    end  
  
end