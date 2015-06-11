class AgentsController < CustomersController
  
  def index
    #@customers = Customer.where(cust_sup: "Agent").paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.json { render json: AgentDatatable.new(view_context, { user: current_user }) }
    end
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
end