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

  def noaccess
  end
  
  def import
    @jobs = JobProgress.in_progress
    render :layout => "application"
  end
  
  def import_countries
    if params[:import_file].nil? then
      flash.now[:warning] = "No file selected!"
      render "import", :layout => "application"
      return
    end  
    
    if !params[:import_file].original_filename.upcase.include?("COUNTRIES") && !params[:import_file].original_filename.upcase.include?("COUNTRY")
      flash[:warning] = "WARNING: Filename does not include the word 'COUNTRIES'"
      render "import", :layout => "application"  
     else
      Admin.import_job(params[:import_file],"Country")
      flash[:success] = "Countries imported!"
      redirect_to import_status_path
    end
  end
  
  def import_destinations
    if params[:import_file].nil? then
      flash.now[:warning] = "No file selected!"
      render "import", :layout => "application"
      return
    end  
    
    if !params[:import_file].original_filename.upcase.include?("DESTINATION")
      flash[:warning] = "WARNING: Filename does not include the word 'Destination'"
      render "import", :layout => "application"       
      return
    end 
    
    Admin.import_job(params[:import_file],"Destination")
    flash[:success] = "Destinations imported!"
    redirect_to import_status_path
  end  

  def import_suppliers
    if params[:import_file].nil? then
      flash.now[:warning] = "No file selected!"
      render "import", :layout => "application"
      return
    end  
    
    if !params[:import_file].original_filename.upcase.include?("SUPPLIERS")
      flash[:warning] = "WARNING: Filename does not include the word 'Suppliers'"
      render "import", :layout => "application"        
      return
    end
    
    Admin.import_job(params[:import_file], "Customer")
    flash[:success] = "Suppliers import begun!"
    redirect_to import_status_path    
  end  

  def import_products
    if params[:import_file].nil? then
      flash.now[:warning] = "No file selected!"
      render "import", :layout => "application"
      return
    end  
    
    if !params[:import_file].original_filename.upcase.include?(params[:type].upcase)
      flash[:warning] = "WARNING: Filename does not match Product type being imported!"
      render "import", :layout => "application"        
      return
    end
    
    Admin.import_job(params[:import_file],params[:type])
    flash[:success] = params[:type].underscore.humanize + " import begun!"
    redirect_to import_status_path
  end
    
  def import_status_job
    @job_progress = JobProgress.find(params[:id])
    respond_to do |format|
      if @job_progress
        format.json { render json: {id: @job_progress.id, complete: @job_progress.complete, progress: @job_progress.progress, total: @job_progress.total,
                                  summary: @job_progress.get_display_details, log: "#{@job_progress.summary} #{@job_progress.log}", name: @job_progress.name} }
      end
    end    
  end
    
  def import_status
    @last_jobs = JobProgress.last(5).reverse
    render :layout => "application"
  end
end
