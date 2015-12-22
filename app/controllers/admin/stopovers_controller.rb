class Admin::StopoversController < ApplicationController
  authorize_resource class: Admin::StopoversController 
  # before_filter :admin_user
  
  def index
    @stopovers = Stopover.all
    respond_to do |format|
      format.html
      format.csv { send_data @stopovers.to_csv }
      format.xls
    end 
  end
  
  def new
    @stopover = Stopover.new
  end

  def edit
    @stopover = Stopover.find(params[:id])
  end
  
  def export
  end  
  def import
  end
  def importfile
    if !params[:file].nil? then 
      Stopover.import(params[:file])
      flash[:success] = "Stopovers imported!"
      redirect_to admin_stopovers_path
    else
      flash[:warning] = "No File!"
      redirect_to admin_stopovers_import_path
    end
  end  
  
  def show
    @stopover = Stopover.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: {name: @stopover.name, id: @stopover.id  }}
    end     
  end
  
  def create
    @stopover = Stopover.new(stopover_params)
    if @stopover.save
      flash[:success] = "Stopover created!"
      redirect_to admin_stopovers_path
    else
      render 'new'
    end
  end  
 
  def destroy
    Stopover.find(params[:id]).destroy
    flash[:success] = "Stopover deleted."
    redirect_to admin_stopovers_path 
  end  
  
  def update
     @stopover = Stopover.find(params[:id])
    if @stopover.update_attributes(stopover_params)
      flash[:success] = "Stopover updated"
      #redirect_to @stopover
      redirect_to admin_stopovers_path 
    else
      render 'edit'
    end
  end
  
private
    def stopover_params
      params.require(:stopover).permit(:name)
    end  
  
end