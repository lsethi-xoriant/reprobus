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
    @entities = Destination.select([:id, :name]).
                            where("name ILIKE :q", q: "%#{params[:q]}%").
                            order('name')
  
    resources_count = @entities.size

    respond_to do |format|
      format.json { render json: {total: resources_count,
                    items: @entities.map { |e| {id: e.id, text: e.name} }} }
    end
  end
  
  def product_search
    if params[:destination] == ""
      @products = Product.select([:id, :name, :country_search, :destination_search, :type]).
                            where("name ILIKE :q OR country_search ILIKE :q OR destination_search ILIKE :q OR type ILIKE :q", q: "%#{params[:q]}%").
                            order('name')
    else
      @products = Product.select([:id, :name, :country_search, :destination_search, :type]).where("destination_id = :destination", destination: params[:destination].to_i).
                            where("name ILIKE :q OR country_search ILIKE :q OR destination_search ILIKE :q", q: "%#{params[:q]}%").
                            order('name') 
    end
  
    resources_count = @products.size

    respond_to do |format|
      format.json { render json: {total: resources_count,
                    items: @products.map { |e| {id: e.id, name: e.name, text: e.name, country: e.country_search, city: e.destination_search, type: e.type  }}}}
    end
  end

  def supplier_search
    @customers = Customer.select([:id, :supplier_name, :cust_sup, :currency_id, :num_days_payment_due]).where("cust_sup ILIKE :p", p: "Supplier" ).
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

private

end