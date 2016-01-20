class Reports::DashboardController < ApplicationController
  authorize_resource class: Reports::DashboardController
  before_filter :signed_in_user
  # before_filter :admin_user
  
  def index
    @collection = 
      [
        [ 'Enquiry', 'Displays enquiries received (created) over a date range'],  
        [ 'Booking Travel', 'Displays Confirmed Bookings, over a date range. Can be filtered by visit to Country and/or Destination (at anytime during trip)'],  
        [ 'Confirmed Booking', 'Displays Confirmed Bookings, over a date range.'],  
        [ 'Supplier', 'Displays Supplier amounts by each Booking, over a date range'],  
        [ 'Destination', 'Displays Confirmed Bookings, over a date range. Can be filtered by Destination which must be visited between entered date range'],  
        [ 'Unpaid Invoice', 'Displays Bookings where invoices have been sent, but where the Booking is not yet Confirmed'] 
      ]
      
  end
end
