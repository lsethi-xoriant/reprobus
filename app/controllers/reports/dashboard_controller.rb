class Reports::DashboardController < ApplicationController
  authorize_resource class: Reports::DashboardController
  before_filter :signed_in_user
  # before_filter :admin_user
  
  def index
    @collection = 
      [
       'Enquiry', 
       'Booking Travel',
       'Confirmed Booking',
       'Supplier',
       'Destination'
      ]
  end
end
