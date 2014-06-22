class StaticPagesController < ApplicationController
  def home
  end

  def about
  end
  
  def dashboard
    @user = current_user
    @assigned_enquiries = @user.assigned_enquiries.paginate(page: params[:page]).per_page(8)    
  end  
  
  def dashboard_list
    @user = current_user
    @assigned_enquiries = @user.assigned_enquiries.paginate(page: params[:page]).per_page(20)    
  end  
end
