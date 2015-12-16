class Reports::DashboardController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user
  
  def index
    @collection = ['Enquiry', 'Itinerary']
  end
end
