class SessionsController < ApplicationController
  layout "plain"
  
  def new
  end

  def create
	  user = User.find_by(email: params[:session][:email].downcase)
	  if user && user.authenticate(params[:session][:password])
		  sign_in user
		  redirect_back_or dashboard_path
      user.send_welcome_email
	  else
		  flash.now[:error] = 'Invalid email/password combination' 
		  render 'new'
	  end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
