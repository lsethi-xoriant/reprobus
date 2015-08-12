class SearchesController < ApplicationController
  before_filter :signed_in_user
 
  def product
    @product = Product.find(params[:id])
    respond_to do |format|
      format.json { render json: {name: @product.name, id: @product.id, text: @product.name, country: @product.country }}
    end
  end
  
  def agent
    @agent = Agent.find(params[:id])
    respond_to do |format|
      format.json { render json: {name: @agent.name, id: @agent.id, text: @agent.supplier_name }}
    end
  end
  
  def agent_search
    @agents = Customer.select([:id, :supplier_name, :cust_sup, :currency_id]).where("cust_sup ILIKE :p", p: "Agent" ).
                            where("supplier_name ILIKE :q", q: "%#{params[:q]}%").
                            order('last_name')
  
    resources_count = @agents.size

    respond_to do |format|
      format.json { render json: {total: resources_count,
        items: @agents.map { |e| {id: e.id, text: "#{e.supplier_name}" }}} }
    end
  end
  
  def country_search
    @entities = Country.select([:id, :name]).
                            where("name ILIKE :q", q: "%#{params[:q]}%").
                            order('name')
  
    resources_count = @entities.size

    respond_to do |format|
      format.json { render json: {total: resources_count,
                    items: @entities.map { |e| {id: e.id, text: e.name} }} }
    end
  end
  
  def currency_search
    @entities = Currency.select([:id, :code,  :currency]).
                            where("code ILIKE :q OR currency ILIKE :q", q: "%#{params[:q]}%").
                            order('code')
  
    resources_count = @entities.size

    respond_to do |format|
      format.json { render json: {total: resources_count,
                    items: @entities.map { |e| {id: e.id, text: "#{e.code} - #{e.currency}"} }} }
    end
  end
  
  def customer_search
    @customers = Customer.select([:id, :last_name, :first_name, :title, :phone, :email ]).where("cust_sup ILIKE :p", p: "Customer" ).
                            where("last_name ILIKE :q OR first_name ILIKE :q", q: "%#{params[:q]}%").
                            order('last_name')
  
    # also add the total count to enable infinite scrolling
    resources_count = @customers.size

    respond_to do |format|
      format.json { render json: {total: resources_count,
                    items: @customers.map { |e| {id: e.id, text: "#{e.first_name} #{e.last_name}", title: e.title,
                    firstname: e.first_name, lastname: e.last_name, email: e.email, phone: e.phone }}} }
    end
  end

  def destination_search
    @entities = Destination.select([:id, :name, :country_id]).
                            where("name ILIKE :q", q: "%#{params[:q]}%").
                            order('name')
                            
    if params[:country] != "" && params[:country] != "0"
      @entities = @entities.where("country_id = :country", country: params[:country].to_i)
    end
   
    resources_count = @entities.size

    respond_to do |format|
      format.json { render json: {total: resources_count,
                    items: @entities.map { |e| {id: e.id, text: e.name} }} }
    end
  end
  
  def product_search
    # this method used by search_products.js for ajax select boxes.
    @products = Product.select([:id, :name, :destination_id, :country_id, :country_search, :destination_search, :type, :default_length]).
                      where("name ILIKE :q OR country_search ILIKE :q OR destination_search ILIKE :q OR type ILIKE :q", q: "%#{params[:q]}%").
                      where.not(type: "Room").where.not(type: "CruiseDay").order('name')

    @products = @products.where("type = :type", type: params[:type]) if (params[:type] != "" && params[:type] != "Type")
    @products = @products.where("destination_id = :destination", destination: params[:destination].to_i)  if params[:destination] != ""
    @products = @products.where("country_id = :country", country: params[:country].to_i) if params[:country] != ""
  
    if params[:page]
      # per number needs to match what is in JS call.
      @products = @products.page(params[:page]).per(30)
    else
      @products = @products.page(1).per(30)
    end
    
    resources_count = @products.total_count
    
    respond_to do |format|
      format.json { render json: {total: resources_count,
                    items: @products.map { |e| {id: e.id, name: e.name, text: e.name, type: e.type,
                          country: e.country_search, city: e.destination_search, numdays: e.default_length,
                          country_id: e.country_id, destination_id: e.destination_id
                    }}}}
    end
  end

  def supplier_search
    @customers = Customer.includes(:currency).select([:id, :supplier_name, :cust_sup, :currency_id, :num_days_payment_due]).where("cust_sup ILIKE :p", p: "Supplier" ).
                            where("supplier_name ILIKE :q", q: "%#{params[:q]}%").
                            order('last_name')
    
    resources_count = @customers.size
    
    respond_to do |format|
      format.json { render json: {total: resources_count,
        items: @customers.map { |e| {id: e.id, text: "#{e.supplier_name}", currency: e.getSupplierCurrencyDisplay, numdays: e.num_days_payment_due}}} }
    end
  end
  
  def template_search
    @templates = ItineraryTemplate.select([:id, :name]).
                            where("name ILIKE :q", q: "%#{params[:q]}%").
                            order('name')
  
    resources_count = @templates.size

    respond_to do |format|
      format.json { render json: {total: resources_count,
                    items: @templates.map { |e| {id: e.id, name: e.name, text: e.name }}}}
    end
  end
  
  
  def user_search
    @users = User.select([:id, :name]).
                            where("name ILIKE :q", q: "%#{params[:q]}%").
                            order('name')
    
    # remove system user if it is in there
    @users = @users.reject { |u| u.name == "System" }
    
    resources_count = @users.size

    respond_to do |format|
      format.json { render json: {total: resources_count,
                  items: @users.map { |e| {id: e.id, text: "#{e.name}"} }} }
    end
  end

  def cruise_info_search
    @cruise = Cruise.find(params[:product])
    #respond_to do |format|
    #  format.json { render json: @cruise.cruise_days.order(id: :asc) }
    #end
    @cruise_legs = @cruise.cruise_days.order(id: :asc)
    render "itinerary_templates/cruise_legs", cruise_legs: @cruise_legs, layout: false
  end

  def product_info_search
    e = Product.find(params[:product])
    
    respond_to do |format|
      format.json { render json: {
                    id: e.id, name: e.name, text: e.name, type: e.type,
                    country: e.country_search, city: e.destination_search, 
                    country_id: e.country_id, destination_id: e.destination_id, 
                    grouptype: e.group_classification, numdays: e.default_length,
                    breakfast: e.includes_breakfast, dinner: e.includes_dinner, lunch: e.includes_lunch,
                    suppliers: e.suppliers.map { |s| {id: s.id, supplier_name: s.supplier_name}},
                    roomtypes: e.rooms.map { |s| {id: s.id, room_type: s.name}}
                    }}
    end
  end
  
private

end