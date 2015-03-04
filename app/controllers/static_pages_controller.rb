class StaticPagesController < ApplicationController
  #before_filter :signed_in_user
  skip_before_filter :signed_in_user, :only => [:home, :about]
  layout "plain"
  
  def home
  end

  def about
  end
  
  def dashboard
    @user = current_user
    
    if params[:remindersOnly] == "y"
      @assigned_enquiries = @user.assigned_enquiries.active.where("enquiries.reminder <= ?", Time.now).paginate(page: params[:page]).per_page(8)
    else
      @assigned_enquiries = @user.assigned_enquiries.active.paginate(page: params[:page]).per_page(8)
    end
    
    render :layout => "application"
  end
  
  def dashboard_list
    @user = current_user
    @assigned_enquiries = @user.assigned_enquiries.active.paginate(page: params[:page]).per_page(20)
    render :layout => "application"
  end

  def currencysearch
    @entities = Currency.select([:id, :code,  :currency]).
                            where("code ILIKE :q OR currency ILIKE :q", q: "%#{params[:q]}%").
                            order('code')
  
    # also add the total count to enable infinite scrolling
  resources_count = Currency.select([:id, :code, :currency]).
      where("code ILIKE :q OR currency ILIKE :q", q: "%#{params[:q]}%").count

    respond_to do |format|
      format.json { render json: {total: resources_count,
                    searchSet: @entities.map { |e| {id: e.id, text: "#{e.code} - #{e.currency}"} }} }
    end
  end
  
  def noaccess
  end
end
