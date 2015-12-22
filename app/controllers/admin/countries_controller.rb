class Admin::CountriesController < ApplicationController
  authorize_resource class: Admin::CountriesController
  # before_filter :admin_user
  
  def index
    @countries = Country.all
    respond_to do |format|
      format.html
      format.csv { send_data @countries.to_csv }
      format.xls
    end 
  end
  
  def new
    @country = Country.new
  end

  def edit
    @country = Country.find(params[:id])
  end
  
  def export
  end  
  def import
  end
  
  def importfile
    if !params[:file].nil? then 
      Country.import(params[:file])
      flash[:success] = "Countries imported!"
      redirect_to admin_countries_path
    else
      flash[:warning] = "No File!"
      redirect_to admin_countries_import_path
    end
  end  
  
  def show
    @country = Country.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: {name: @country.name, id: @country.id  }}
    end     
  end
  
  def create
    @country = Country.new(country_params)
    if @country.save
      flash[:success] = "Country created!"
      redirect_to admin_countries_path
    else
      render 'new'
    end
  end  
 
  def destroy
    Country.find(params[:id]).destroy
    flash[:success] = "Country deleted."
    redirect_to admin_countries_path 
  end  
  
  def update
     @country = Country.find(params[:id])
    if @country.update_attributes(country_params)
      flash[:success] = "Country updated"
      #redirect_to @country
      redirect_to admin_countries_path 
    else
      render 'edit'
    end
  end
  
private
    def country_params
      params.require(:country).permit(:name, :visa_details, :warnings, :vaccinations)
    end  
  
end