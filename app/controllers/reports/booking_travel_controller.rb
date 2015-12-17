class Reports::BookingTravelController < ApplicationController
  before_filter :define_initial_parameters, unless: "params[:reports_search]"
  before_filter :define_search_parameters, if: "params[:reports_search]"

  def index
    @users = User.where.not(name: "System")
    @countries = Country.all
    @itineraries = 
      ReportService.booking_travel_search(@from, @to, @user, @country)
  end

  private

    def define_initial_parameters
      @from, @to = 200.years.ago, Date.today
    end

    def define_search_parameters
      @from, @to   = params[:reports_search][:from], params[:reports_search][:to]
      @user        = params[:reports_search][:user_id]
      @country     = params[:reports_search][:country_id]
    end

end