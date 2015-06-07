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
  
  
        
  def product_search
    @products = Product.select([:id, :name, :country, :city, :type]).
                            where("name ILIKE :q OR country ILIKE :q OR city ILIKE :q", q: "%#{params[:q]}%").
                            order('name')
  
    resources_count = @products.size

    respond_to do |format|
      format.json { render json: {total: resources_count,
                    items: @products.map { |e| {id: e.id, name: e.name, text: e.name, country: e.country, city: e.city, type: e.type  }}}}
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