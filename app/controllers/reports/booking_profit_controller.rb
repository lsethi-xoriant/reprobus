class Reports::BookingProfitController < ApplicationController
  authorize_resource class: Reports::BookingProfitController
  before_filter :define_parameters

  def index
    @structure = structure
    @users = User.where.not(name: "System").order(:name)
    @itinerary_prices = ReportService.booking_profit_search(@from, @to, @user)
  end

  private

    def structure
      {
        'Booking ID' => 'ItineraryPrice.itinerary.id (link to edit itinerary screen)',
        'Customer Name' => 'ItineraryPrice.itinerary.lead_customer.fullname',
        'Agent' => 'ItineraryPrice.itinerary.agent.supplier_name(if present)',
        'Consultant' => 'ItineraryPrice.itinerary.user.name',
        'Currency' => 'ItineraryPrice.currency.code',
        'Sale Total' => 'ItineraryPrice.sale_total (formatted for currency)',
        'Sell Price' => 'ItineraryPrice.get_total_sell_price (formatted for currency)',
        'Profit Amount' => 'ItineraryPrice.get_total_profit (formatted for currency)',
        'Invoices Matched' => 'All supplier_itinerary_price_items that are not a dummy_supplier have invoice_matched = true. Output for this would be Y/N.'
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