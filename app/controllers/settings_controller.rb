class SettingsController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user, only: [:edit, :update]
  skip_before_filter :signed_in_user, only: [:dp_callback]
  
  before_action :setCompanySettings
  
  def show
  end
  
  def edit
  end
  
  def addEmailTriggers
    #more code to whip through triggers and update them.
    @emailTabActive = true
    if @setting.update_attributes(settings_params)
      flash.now[:success] = "Settings updated"
      render 'email'
    else
      render 'email'
    end
  end
  
  def addcurrency
    curr = Currency.find(params[:currency_id])
    er = @setting.exchange_rates.find_by_currency_code(curr.code)
    
    if er
      # we are updating
      pass = er.update_attributes(currency_code: curr.code, exchange_rate: params[:exchange_rate])
      
    else # we are creating
      pass = @setting.exchange_rates.create(currency_code: curr.code, exchange_rate: params[:exchange_rate])
    end
    
    @currTabActive = true
    if pass
      flash[:success] = "New currency override added"
      render 'currency'
    else
      flash[:error] = "Error adding currency override. Please check all fields completed"
      render 'currency'
    end
  end

  def update
 
    if @setting.update_attributes(settings_params)
      
      
      flash[:success] = "Settings updated"
      
      if params[:redirect] == "integration"
        redirect_to integration_settings_path
      else
        redirect_to @setting
      end
    else
      #render 'edit'
      render params[:redirect]
    end
  end
  
  def syncInvoices
    invoices = []
    Invoice.all.each do |inv|
      if inv.xero_id
       invoices << inv
      end
    end
    logStr = ""
    xero = Xero.new()
    logStr = xero.sync_invoices(invoices)
    
    @logStr = logStr
    @invoices = invoices
    respond_to do |format|
        format.js
    end
  end
  
  def general
  end
  
  def operation
  end
  
  def email
  end
  
  def operation
  end
  
  def integration
  end
  
  def itinerary
  end  
  
  def db_authorize
    require 'dropbox_sdk'
  
    dbsession = DropboxSession.new(ENV["DROPBOX_APP_KEY"],ENV["DROPBOX_APP_KEY_SECRET"])
    #serialize and save this DropboxSession
    session[:dropbox_session] = dbsession.serialize
    #pass to get_authorize_url a callback url that will return the user here
    redirect_to dbsession.get_authorize_url url_for(:action => 'db_callback')
  end
   

  def db_callback
    require 'dropbox_sdk'
  
    dbsession = DropboxSession.deserialize(session[:dropbox_session])
    dbsession.get_access_token #we've been authorized, so now request an access_token
    session[:dropbox_session] = dbsession.serialize
    @setting.update_attributes(:dropbox_session => session[:dropbox_session])
    session.delete :dropbox_session
    flash[:success] = "You have successfully authorized with dropbox."
    redirect_to integration_settings_path
  end # end of dropbox_callback action
   
  def dp_unauthorize
    require 'dropbox_sdk'
  
    session[:dropbox_session] = nil
    @setting.dropbox_session = nil
    @setting.save!
  end
  
private
  def settings_params
    params.require(:setting).permit(:company_name, :pxpay_user_id, :pxpay_key,
    :use_xero, :xero_consumer_key, :xero_consumer_secret, :currency_id, :itinerary_notes,
    :payment_gateway, :cc_mastercard, :cc_visa, :cc_amex, :dropbox_user, :itinerary_excludes,
    :dropbox_session, :use_dropbox, :dropbox_default_path, :itinerary_includes,
    triggers_attributes: [:id, :email_template_id, :num_days],
    company_logo_attributes: [:id, :image_local, :image_remote_url],
    itinerary_default_image_attributes: [:id, :image_local, :image_remote_url])
  end
end
