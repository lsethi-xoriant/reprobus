class Admin::CustomerInteractionsController < ApplicationController
  before_filter :admin_user
  protect_from_forgery with: :null_session
  
  def index
    @customer_interactions = CustomerInteraction.all
    respond_to do |format|
      format.html
    end 
  end

end