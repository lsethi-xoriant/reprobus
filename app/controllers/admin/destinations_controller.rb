class Admin::DestinationsController < ApplicationController
  before_filter :admin_user
  
  def index
    @destinations = Destination.all
    respond_to do |format|
      format.html
      format.csv { send_data @destinations.to_csv }
      format.xls
    end 
  end
  def new
    @destination = Destination.new
  end

  def edit
    @destination = Destination.find(params[:id])
  end
 
  def export
  end
  def import
  end  
  def importfile
    if !params[:file].nil? then 
      Destination.import(params[:file])
      flash[:success] = "Destinations imported!"
      redirect_to admin_destinations_path
    else
      flash[:warning] = "No File!"
      redirect_to admin_destinations_import_path
    end
  end  
  
  def show
    @destination = Destination.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: {name: @destination.name, id: @destination.id  }}
    end       
  end
  
  def create
    @destination = Destination.new(destination_params)
    if @destination.save
      flash[:success] = "Destination created!"
      redirect_to admin_destinations_path
    else
      render 'new'
    end
  end  
  
  def destroy
    Destination.find(params[:id]).destroy
    flash[:success] = "Destination deleted."
    redirect_to admin_destinations_path 
  end  
  
  def update
     @destination = Destination.find(params[:id])
    if @destination.update_attributes(destination_params)
      flash[:success] = "Destination updated"
      #redirect_to @destination
      redirect_to admin_destinations_path 
    else
      render 'edit'
    end
  end
  
private
    def destination_params
      params.require(:destination).permit(:name)
    end  
  
end