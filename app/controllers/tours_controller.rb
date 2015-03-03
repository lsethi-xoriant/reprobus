class ToursController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user, only: :destroy
  
  def index
    @tours = Tour.paginate(page: params[:page])
  end
  
  def new
    @tour = Tour.new
  end

  def show
    @tour = Tour.find(params[:id])
  end
  
  def edit
    @tour = Tour.find(params[:id])
  end
  
  def create
    @tour = Tour.new(tour_params)
    if @tour.save
      flash[:success] = "Tour created!"
      redirect_to @tour
    else
      render 'new'
    end
  end

  def update
     @tour = Tour.find(params[:id])
    if @tour.update_attributes(tour_params)
      flash[:success] = "Tour updated"
      redirect_to @tour
    else
      render 'edit'
    end
  end
  
private
    def tour_params
      params.require(:tour).permit(:tourName, :tourPrice, :destination,
                                   :country, :image, :remote_image_url)
    end
end
