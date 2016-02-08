class Reports::BookingProfitController < ApplicationController
  authorize_resource class: Reports::BookingProfitController
  before_filter :define_parameters

  def index
    @structure = structure
    @users = User.where.not(name: "System").order(:name)
    @itinerary_prices = ReportService.booking_profit_search(@from, @to, @user)

    respond_to do |format|
      format.html
      format.xls
      format.csv do
        send_data ReportService.generate_csv(@itinerary_prices, @structure)
      end
    end
  end

  private

    def structure
      {
        'Booking ID' => 'try(:itinerary).try(:id)',
        'Customer Name' => 'try(:itinerary).try(:lead_customer).try(:fullname)',
        'Agent' => 'try(:itinerary).try(:agent).try(:supplier_name)',
        'Consultant' => 'try(:itinerary).try(:user).try(:name)',
        'Currency' => 'try(:currency).try(:code)',
        'Sale Total' => 'try(:sale_total)',
        'Sell Price' => 'try(:get_total_sell_price)',
        'Profit Amount' => 'try(:get_total_profit)',
        'Invoices Matched' => 'try(:invoices_matched)'
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
      end

    end

end