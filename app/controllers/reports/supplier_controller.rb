class Reports::SupplierController < ApplicationController
  before_filter :define_parameters

  def index
    @structure = structure
    @suppliers = Customer.where.not(supplier_name: nil).order('supplier_name ASC')
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
        'Booking ID'           => 'supplier_itinerary_price.try(:itinerary).try(:id)',
        'Customer name'        => 'supplier_itinerary_price.try(:itinerary).try(:lead_customer).try(:fullname_with_title)',
        'Supplier'             => 'supplier.try(:supplier_name)',
        'Value'                => 'price_total',
        'Paid date / Due date' => 'itinerary_price.try(:final_balance_due)'
      }
    end

    def define_parameters
      search_params = params.try(:[], :reports_search)
      @from, @to = 
        ReportService.prepare_dates(
          search_params.try(:[], :from),
          search_params.try(:[], :to)
        )
      @search_by = search_params.try(:[], :search_by).presence || 'confirmed_date'
      @supplier = search_params.try(:[], :supplier_id).presence
    end

end