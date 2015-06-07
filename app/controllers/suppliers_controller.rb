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
      format.json { render json: {name: @customer.supplier_name, id: @customer.id, currency: @customer.getSupplierCurrencyDisplay  }}
    end
  end
  
  def create
    super
  end
  
  def update
    super
  end
end