class Admin::DestinationsController < ApplicationController
  before_filter :admin_user
  
  def index
    @destinations = Destination.paginate(page: params[:page])
  end
  def new
    @destination = Destination.new
  end

  def edit
    @destination = Destination.find(params[:id])
  end
  
  def show
    @destination = Destination.find(params[:id])
  end
  
  def create
    @destination = Destination.new(destination_params)
    if @destination.save
      flash[:success] = "Destination created!"
      redirect_to admin_destination_path(@Destination)
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
      redirect_to @destination
    else
      render 'edit'
    end
  end
  
private
    def destination_params
      params.require(:destination).permit(:name)
    end  
  
end