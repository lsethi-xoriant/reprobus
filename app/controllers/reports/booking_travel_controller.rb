class Reports::BookingTravelController < ApplicationController
  before_filter :define_initial_parameters

  def index
    @users = User.where.not(name: "System")
    @countries = Country.all
  end

  private
    def define_initial_parameters
      return unless params[:reports_search]
      @from, @to   = params[:reports_search][:from], params[:reports_search][:to]
      @assigned_to = params[:reports_search][:assigned_to_id]
      @country     = params[:reports_search][:country_id]
    end
end