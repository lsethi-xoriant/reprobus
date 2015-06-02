class UsersController < ApplicationController
  before_filter :signed_in_user, except: [:new, :create]
  before_filter :correct_user, only: [:edit, :update, :delete]
  before_filter :admin_user, only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @assigned_enquiries = @user.assigned_enquiries.active.paginate(page: params[:page])
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
      flash[:success] = "Welcome to the Super App!"
      redirect_to @user
    else
      render 'new', :layout => "plain"
    end
  end
  
  def edit
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

  def usersearch
    @users = User.select([:id, :name]).
                            where("name ILIKE :q", q: "%#{params[:q]}%").
                            order('name')
    
    # remove system user if it is in there
    @users = @users.reject { |u| u.name == "System" }
    
    # also add the total count to enable infinite scrolling
    resources_count = @users.size

    respond_to do |format|
      format.json { render json: {total: resources_count,
                  searchSet: @users.map { |e| {id: e.id, text: "#{e.name}"} }} }
    end
  end

private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, (:admin if @current_user && @current_user.admin?))
    end
	
    def correct_user
      @user = User.find(params[:id])
      if @user.isSystemUser then
        redirect_to(noaccess_url)
      end
      redirect_to(noaccess_url) unless current_user?(@user) || current_user.admin?
    end
end
