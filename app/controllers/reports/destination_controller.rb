class Reports::DestinationController < ApplicationController
  authorize_resource class: Reports::DestinationController
  before_filter :define_parameters

  def index
    @structure = structure

    @users = User.where.not(name: "System")
    @countries = Country.all
    @itineraries = 
      ReportService.destination_search(@from, @to, @user, @country, @destination)

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

    def define_parameters
      search_params = params.try(:[], :reports_search)
      @from, @to = 
        ReportService.prepare_dates(
          search_params.try(:[], :from),
          search_params.try(:[], :to)
        )
      
      if search_params.present?
        @user = search_params[:user_id]
        @country = search_params[:country_id]
        @destination = search_params[:destination_id]
      end

    end
end