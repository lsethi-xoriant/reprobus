class StaticPagesController < ApplicationController
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

end
