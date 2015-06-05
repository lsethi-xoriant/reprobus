class Products::ProductsController < ApplicationController
  include ProductsHelper
  
  before_filter :signed_in_user
  before_filter :admin_user
  
  def index
    @products = Product.where(type: params[:type]).paginate(page: params[:page])
  end
  
  def new
    @product = Product.new
    @product.type = params[:type]
  end
  
  def create
    @product = Product.new(product_params)
    #@product.type = params[:type]
    
   # @product = product_type.new(product_params)

    if @product.save
      flash[:success] = "#{@product.name} created!"
      redirect_to product_index_path(@product)
    else
      render 'new'
    end
  end
  
  def edit
    @product = Product.find(params[:id])
  end
  
  def update
    @product = Product.find(params[:id])
    
    if @product.update_attributes(product_params)
      flash[:success] = "#{@product.name} updated!"
      redirect_to product_index_path @product
    else
      render 'new'
    end
  end

private
    def product_params
      params.require(:product).permit(:type, :name, :description, :country, :city,
        :price_single, :price_double, :price_tripple, :product_type, :room_type, :rating, :destination, :default_length,
        :supplier_id)
    end
end