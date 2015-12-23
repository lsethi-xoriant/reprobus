class Reports::SupplierController < ApplicationController
  before_filter :define_initial_parameters, unless: "params[:reports_search]"
  before_filter :define_search_parameters, if: "params[:reports_search]"

  def index
    @structure = structure
    @suppliers = Customer.where.not(supplier_name: nil)
    @supplier_itinerary_price_items = 
      ReportService.supplier_search(@from, @to, @search_by, @supplier)

    respond_to do |format|
      format.html
      format.csv do
        csv_string = 
          ReportService.generate_csv(@supplier_itinerary_price_items, @structure)
        send_data csv_string
      end
      format.xls
    end
  end

  private

    def structure
      {
        'Booking ID'           => 'itinerary_price.try(:itinerary).try(:id)',
        'Customer name'        => 'itinerary_price.try(:itinerary).try(:lead_customer).try(:fullname_with_title)',
        'Supplier'             => 'supplier.try(:supplier_name)',
        'Value'                => 'price_total',
        'Paid date / Due date' => 'itinerary_price.try(:final_balance_due)'
      }
    end

    def define_initial_parameters
      @from, @to = 1.month.ago.beginning_of_day, Date.today.end_of_day
      @search_by = :confirmed_date
    end

    def define_search_parameters
      @from = params[:reports_search][:from].presence
      @to   = params[:reports_search][:to].presence
      @supplier = params[:reports_search][:supplier_id].presence
      @search_by = params[:reports_search][:search_by].presence
    end

end