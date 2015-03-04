module SessionsHelper
  def is_number?(mystring)
    true if Float(mystring) rescue false
  end
  
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.hash(remember_token))
    self.current_user = user
    #session[:user_id] = user.id
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.hash(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
    #session[:user_id] = nil
  end
  
  def current_user=(user)
    @current_user = user
  end
 
  def current_user
    remember_token = User.hash(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
    
#    tempUser ||= session[:user_id] && User.find(session[:user_id])
    #if tempUser.nil?
#      remember_token = User.hash(cookies[:remember_token])
 #     tempUser ||= User.find_by(remember_token: remember_token)
 #     if !tempUser.nil? && ! tempUser.remember_me then
  #      tempUser = nil
   #   end
   # end
#    @current_user = tempUser;
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "<strong>Please sign in.</strong>"
    end
  end
	
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end
  
private
	  def admin_user
      redirect_to(noaccess_url) unless current_user.admin?
    end
end
