class Admin::DestinationsController < ApplicationController
  before_filter :admin_user, except: ['search_by_name']
  before_action :set_settings, only: [:new, :edit]
  protect_from_forgery with: :null_session
  before_action :setCompanySettings
  
  def index
    @destinations = Destination.includes(:country).all
    respond_to do |format|
      format.html
      format.csv { send_data @destinations.to_csv }
      format.xls
    end 
  end
  def new
    @destination = Destination.new
    @destination.default_image = ImageHolder.new if !@destination.default_image
  end

  def edit
    @destination = Destination.find(params[:id])
    @destination.default_image = ImageHolder.new if !@destination.default_image
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

  def search_by_name
    search_params = params[:destinations].present? ? params[:destinations] : ''
    result = Destination.where(name: params[:destinations]).uniq
    selected = 
      if params[:selected].present?
        selected_destination = result
                                .select { |dest| dest.name == params[:selected] }
        selected_destination.any? ? selected_destination[0].default_image_id : nil
      end
    respond_to do |format|
      html = render_to_string(
          partial:    'itineraries/itinerary_destinations_select',
          locals:     { result: result, selected: selected }
      )
      format.json do
        render json: {
            result: result,
            status: :success,
            html:   html
        }
      end
    end
  end
  
private

  def destination_params
    params.require(:destination).permit(:name, :country_id, :default_image,
      default_image_attributes: [:id, :image_local, :image_remote_url])
  end

  def set_settings
    @setting = Setting.first if Setting.any?
  end
  
end
