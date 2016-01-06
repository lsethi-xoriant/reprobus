class Reports::BookingTravelController < ApplicationController
  authorize_resource class: Reports::BookingTravelController
  before_filter :define_initial_parameters, unless: "params[:reports_search]"
  before_filter :define_search_parameters, if: "params[:reports_search]"

  def index
    @structure = structure

    @users = User.where.not(name: "System")
    @countries = Country.all
    @itineraries = 
      ReportService.booking_travel_search(@from, @to, @user, @country)

    respond_to do |format|
      format.html
      format.xls
      format.csv do
        send_data ReportService.generate_csv(@itineraries, @structure)
      end
    end
  end

  private

    def structure
      {
        'Booking ID'    => 'id',
        'Name'          => 'name',
        'Customer Name' => 'lead_customer.try(:fullname)',
        'Agent'         => 'agent.try(:supplier_name)',
        'Start Date'    => 'start_date',
        'End Date'      => 'end_date',
        'Status'        => 'status'
      }
    end

    def define_initial_parameters
      @from, @to = 1.month.ago.beginning_of_day, Date.today.end_of_day
    end

    def define_search_parameters
      @from        = params[:reports_search][:from].to_date.beginning_of_day
      @to          = params[:reports_search][:to].to_date.end_of_day
      @user        = params[:reports_search][:user_id]
      @country     = params[:reports_search][:country_id]
    end

end