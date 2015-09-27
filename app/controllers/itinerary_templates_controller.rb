class ItineraryTemplatesController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user, only: :destroy
  before_action :setCompanySettings
  
  def index
    @templates = ItineraryTemplate.page(params[:page])
  end
  
  def new
    @template = ItineraryTemplate.new
    @template.itinerary_default_image.new
  end

  def show
    @template = ItineraryTemplate.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: {name: @template.fullname, id: @template.id  }}
    end
  end
  
  def edit
    @template = ItineraryTemplate.find(params[:id])
    @template.itinerary_default_image = ImageHolder.new if !@template.itinerary_default_image
  end
  
  def create
    @template = ItineraryTemplate.new(template_params)
   
    if @template.save
      flash[:success] = "Template created!"
      redirect_to  edit_itinerary_template_path(@template)
    else
      render 'new'
    end
  end

  def update
     @template = ItineraryTemplate.find(params[:id])
     
    if @template.update_attributes(template_params)
      flash[:success] = "Template updated"
      redirect_to edit_itinerary_template_path(@template)
    else
      render 'edit'
    end
  end

  def destroy
    ItineraryTemplate.find(params[:id]).destroy
    flash[:success] = "ItineraryTemplate deleted."
    redirect_to itinerary_templates_url
  end
  
private
    def template_params
      params.require(:itinerary_template).permit(:name, :includes, :excludes, :notes,
      itinerary_template_infos_attributes: [:id, :product_id, :supplier_id, :position, :length, :room_type, :days_from_start, :_destroy ],
      itinerary_default_image_attributes: [:id, :image_local, :image_remote_url])
    end
end
