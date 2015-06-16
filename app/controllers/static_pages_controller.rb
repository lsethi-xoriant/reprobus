class StaticPagesController < ApplicationController
  before_filter :signed_in_user
  skip_before_filter :signed_in_user, :only => [:home, :about]
  layout "plain"
  
  def home
  end

  def about
  end
  
  def dashboard
    @user = current_user
    
    if params[:remindersOnly] == "y"
      @assigned_enquiries = @user.assigned_enquiries.active.where("enquiries.reminder <= ?", Time.now).paginate(page: params[:page]).per_page(9)
    else
      @assigned_enquiries = @user.assigned_enquiries.active.paginate(page: params[:page]).per_page(9)
    end
    
    render :layout => "application"
  end
  
  def dashboard_list
    @user = current_user
    @assigned_enquiries = @user.assigned_enquiries.active.paginate(page: params[:page]).per_page(20)
    render :layout => "application"
  end

  def snapshot
    @user = current_user
    @assigned_enquiries = @user.assigned_enquiries.active.paginate(page: params[:page]).per_page(20)
    render :layout => "application"
  end

  def currencysearch
    @entities = Currency.select([:id, :code,  :currency]).
                            where("code ILIKE :q OR currency ILIKE :q", q: "%#{params[:q]}%").
                            order('code')
  
    # also add the total count to enable infinite scrolling
    resources_count = @entities.size

    respond_to do |format|
      format.json { render json: {total: resources_count,
                    searchSet: @entities.map { |e| {id: e.id, text: "#{e.code} - #{e.currency}"} }} }
    end
  end
  
  def import
    render :layout => "application"
  end
  
  def import_countries
    if !params[:file].nil? then 
      @country_import_str = Country.import(params[:file])
      flash[:success] = "Countries imported!"
      redirect_to import_path
    else
      flash[:warning] = "No File!"
      redirect_to import_path
    end
  end
  
  def import_destinations
    if !params[:file].nil? then 
      @destionation_import_str = Destination.import(params[:file])
      flash[:success] = "Destinations imported!"
      redirect_to import_path
    else
      flash[:warning] = "No File!"
      redirect_to import_path
    end
  end  

  def import_suppliers
    if !params[:file].nil? then 
      @supplier_import_str = Customer.importSupplier(params[:file])
      flash[:success] = "Suppliers imported!"
      redirect_to import_path
    else
      flash[:warning] = "No File!"
      redirect_to import_path
    end
  end  


  def import_products
    if !params[:file].nil? then 
      @supplier_import_str = Product.import(params[:file],params[:type])
      flash[:success] = params[:type].pluralize(2) + " imported!"
      redirect_to import_path
    else
      flash[:warning] = "No File!"
      redirect_to import_path
    end
  end
    
  
  
  def noaccess
  end
end
