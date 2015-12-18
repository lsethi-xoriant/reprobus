class Products::DashboardController < ApplicationController
  authorize_resource class: Products::DashboardController
  
  before_filter :signed_in_user
  before_filter :admin_user
  
  def index
  end
end
