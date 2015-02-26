class SettingsController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user, only: [:show, :edit, :update]
  
  
  def show
    @setting = Setting.find(params[:id])
  end
  
  def edit
    @setting = Setting.find(params[:id])
  end
  
  def addcurrency 
    @setting = Setting.find(params[:setting_id])
    curr = Currency.find(params[:currency_id])
    er = @setting.exchange_rates.find_by_currency_code(curr.code)
    
    if er
      # we are updating
      pass = er.update_attributes(currency_code: curr.code, exchange_rate: params[:exchange_rate]) 
      
    else # we are creating
      pass = @setting.exchange_rates.create(currency_code: curr.code, exchange_rate: params[:exchange_rate])
    end
    
    if pass 
      flash[:success] = "New currency override added"
      @currTabActive = true
      render 'edit'
    else
      flash[:danger] = "Error adding currency override. Please check all fields completed"
      @currTabActive = true
      render 'edit'     
    end
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
      :use_xero, :xero_consumer_key, :xero_consumer_secret, :currency_id )      
    end  
end
