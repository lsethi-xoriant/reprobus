class Admin::StopoversController < ApplicationController
  before_filter :admin_user
  
  def index
    @stopovers = Stopover.paginate(page: params[:page])
  end
  def new
    @stopover = Stopover.new
  end

  def edit
    @stopover = Stopover.find(params[:id])
  end
  
  def show
    @stopover = Stopover.find(params[:id])
  end
  
  def create
    @stopover = Stopover.new(stopover_params)
    if @stopover.save
      flash[:success] = "Stopover created!"
      redirect_to admin_stopover_path(@stopover)
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
      redirect_to @stopover
    else
      render 'edit'
    end
  end
  
private
    def stopover_params
      params.require(:stopover).permit(:name)
    end  
  
end