class Reports::DashboardController < ApplicationController
  authorize_resource class: Reports::DashboardController
  before_filter :signed_in_user
  # before_filter :admin_user
  
  def index
    @collection = 
      [
        [ 'Enquiry', 'Enquiry Report'],  
        [ 'Booking Travel', 'Booking Travel Report'],  
        [ 'Confirmed Booking', 'Confirmed Booking Report'],  
        [ 'Supplier', 'Supplier Report'],  
        [ 'Destination', 'Destination Report'],  
        [ 'Unconfirmed Booking', 'Unconfirmed Booking Report'] 
      ]
      
  end
end
