class UsersController < ApplicationController
  before_filter :signed_in_user, except: [:new, :create]
  before_filter :correct_user, only: [:edit, :update, :destroy]
  before_filter :admin_user, only: :destroy
  
  def index
    @users = User.page(params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @assigned_enquiries = @user.assigned_enquiries.active.page(params[:page])
    respond_to do |format|
      format.html
      format.json { render json: {name: @user.name, id: @user.id  }}
    end
  end
  
  def new
    @user = User.new
    render :layout => "plain"
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
	    sign_in @user
      @user.send_welcome_email
      flash[:success] = "Welcome to tripeze!"
      redirect_to @user
    else
      render 'new', :layout => "plain"
    end
  end
  
  def edit
    @roles = Role.all
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end
  
private
    def user_params
      params
        .require(:user)
        .permit(:name, :email, :password,
                :password_confirmation, {role_ids: []},
                (:admin if @current_user && @current_user.admin?))
    end
	
    def correct_user
      @user = User.find(params[:id])
      if @user.isSystemUser then
        redirect_to(noaccess_url)
      end
      redirect_to(noaccess_url) unless current_user?(@user) || current_user.admin?
    end
end
