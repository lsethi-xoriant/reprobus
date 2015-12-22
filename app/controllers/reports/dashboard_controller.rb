class Reports::DashboardController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user
  
  def index
    @collection = 
      [
       'Enquiry', 
       'Booking Travel',
       'Confirmed Booking',
       'Supplier'
      ]
  end
end
