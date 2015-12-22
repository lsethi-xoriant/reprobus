class Admin::DashboardController < ApplicationController
  authorize_resource class: Admin::DashboardController
  before_filter :signed_in_user
  # before_filter :admin_user
  
  def index
  end
end
