class Products::ProductsController < ApplicationController
  authorize_resource class: Products::ProductsController 
  include ProductsHelper
  
  before_filter :signed_in_user
  # before_filter :admin_user
  
  def index
    #@products = Product.includes(:supplier).where(type: params[:type])
    respond_to do |format|
      format.html
      format.json { render json: ProductDatatable.new(view_context, { user: current_user, type: params[:type] }) }
    end    
  end
  
  def new
    @setting = Setting.find(1)
    
    @product = params[:type].constantize.new()

    #@product = Product.new
    #@product.type = params[:type]
  end
  
  def copy
    @setting = Setting.find(1)
    
    original_product = Product.where(id: params[:original_product_id]).first
    
    @product = original_product.deep_clone include: [:rooms, :suppliers]
  
    @product.name = original_product.name + ' COPY'
    @product.destination = original_product.destination
    @product.country_id = original_product.country_id
    @product.supplier_ids = original_product.supplier_ids
    
    @original_product_id = params[:original_product_id]
  end
  
  def create
    @setting = Setting.find(1)
    
    @product = Product.new(product_params)
    
    #@product.type = params[:type]
    @product.image = params[:image]
    
    if @product.save
      flash[:success] = "#{@product.name} created!"
      redirect_to product_index_path(@product, :html)
    else
      render 'new'
    end
  end
  
  def edit
    @product = Product.find(params[:id])
    @setting = Setting.find(1)
  end
  
  def update
    @setting = Setting.find(1)
    @product = Product.find(params[:id])
   
    if @product.update_attributes(product_params)
      flash[:success] = "#{@product.name} updated!"
      redirect_to get_edit_path(@product)
    else
      render 'edit'
    end
  end
  
  def destroy
    @product = Product.find(params[:id]).destroy
    flash[:success] = "#{@product.type} deleted."
    redirect_to product_index_path(@product, :html)
  end
  

private
    def product_params
      params.require(:product).permit(:original_product_id, :type, :name, :description, :country_id, :phone,
        :destination_id, :image, :image_cache, {:supplier_ids => []}, :address, :price_single, 
        :price_double, :price_triple,:room_type, :rating, :default_length, :image_remote_url,
        :group_classification, :includes_breakfast, :includes_lunch, :includes_dinner,
        rooms_attributes: [:id, :hotel_id, :type, :name, :description, :country_id, 
        :destination_id, :image, :image_cache, :price_single, :price_double, :price_triple, 
        :room_type, :rating, :default_length, :image_remote_url, {:supplier_ids => []}, :_destroy],
        cruise_days_attributes: [:id, :cruise_id, :type, :name, :description, :country_id, 
        :destination_id, :image, :image_cache, :price_single, :price_double, :price_triple, 
        :room_type, :rating, :default_length, :image_remote_url, {:supplier_ids => []}, :_destroy])
    end
end