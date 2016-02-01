class Reports::UnpaidInvoiceController < ApplicationController
  authorize_resource class: Reports::UnpaidInvoiceController

  def index
    if params[:reports_search]
      @from = params[:reports_search][:from].presence
      @to   = params[:reports_search][:to].presence
      @user = params[:reports_search][:user_id].presence
    end

    @structure = structure
    @users = User.where.not(name: "System").order(:name)
    @itinerary_prices = 
      ReportService.unpaid_invoices(@from, @to, @user)

    respond_to do |format|
      format.html
      format.csv do
        csv_string = ReportService.generate_csv(@itinerary_prices, @structure)
        send_data csv_string
      end
      format.xls
    end
  end

  private

    def structure
      {
        'Booking ID'    => 'id',
        'Booking name'  => 'try(:itinerary).try(:name)',
        'Customer name' => 
          'try(:itinerary).try(:lead_customer).try(:fullname_with_title)',
        'Booking Start Date' => 'try(:itinerary).try(:start_date)',
        'Consultant'    => 'try(:itinerary).try(:user).try(:name)',
        'Sale Value'    => 'try(:sale_total).try(:to_s)',
        'Profit amount' => 'try(:get_total_profit)',
        'Agent'         => 'try(:itinerary).try(:agent).try(:supplier_name)'
      }
    end

end
