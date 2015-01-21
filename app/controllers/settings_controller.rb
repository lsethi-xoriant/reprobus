class SettingsController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user, only: [:show, :edit, :update]
  
  
  def show
    @setting = Setting.find(params[:id])
  end
  
  def edit
    @setting = Setting.find(params[:id])
  end
  

  def update
     @setting = Setting.find(params[:id])
    if @setting.update_attributes(settings_params)
      flash[:success] = "Settings updated"
      redirect_to @setting
    else
      render 'edit'
    end
  end

private
  def settings_params
    params.require(:setting).permit(:company_name, :pxpay_user_id, :pxpay_key,
        :use_xero, :xero_consumer_key, :xero_consumer_secret)      
    end  
end
