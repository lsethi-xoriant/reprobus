class SuppliersController < CustomersController
  
  def index
    @customers = Customer.where(cust_sup: "Supplier").paginate(page: params[:page])
  end
  
  def new
    super
  end

  def show
    @customer = Customer.find(params[:id])
    #@activities = @customer.activities.order('created_at DESC').page(params[:page]).per_page(5)
    respond_to do |format|
      format.html
      format.json { render json: {name: @customer.fullname, id: @customer.id  }}
    end    
  end 
  
  def create
    super
  end
  
  def update
    super
  end
  
  def customersearch
    @customers = Customer.select([:id, :supplier_name]).where("cust_sup ILIKE :p", p: "Supplier" ).
                            where("supplier_name ILIKE :q", q: "%#{params[:q]}%").
                            order('last_name')
  
    # also add the total count to enable infinite scrolling
    resources_count = Customer.select([:id, :last_name, :first_name]).where("cust_sup ILIKE :p", p: "Supplier" ).
      where("supplier_name ILIKE :q", q: "%#{params[:q]}%").count

    respond_to do |format|
      format.json { render json: {total: resources_count, 
                    searchSet: @customers.map { |e| {id: e.id, text: "#{e.supplier_name}"} }} }
    end
  end
end