class Reports::EnquiryController < ApplicationController
  authorize_resource class: Reports::EnquiryController

  def index
    if params[:reports_search]
      @from        = params[:reports_search][:from].presence
      @to          = params[:reports_search][:to].presence
      @stage       = params[:reports_search][:stage].presence
      stage        = @stage ? @stage : Enquiry::STATUSES ## If there is no values we choose all statuses by default
      @assigned_to = params[:reports_search][:assigned_to_id]
    end

    @structure = structure
    @users = User.where.not(name: "System")
    @enquiries = ReportService.enquiry_search(@from, @to, stage, @assigned_to)

    respond_to do |format|
      format.html
      format.csv do
        csv_string = ReportService.generate_csv(@enquiries, @structure)
        send_data csv_string
      end
      format.xls
    end
  end

  private

    def structure
      {
        'Enquiry ID'            => 'id',
        'Enquiry name'          => 'name',
        'Status'                => 'stage',
        'Customer name'         => 'try(:lead_customer).try(:fullname)',
        'Consultant'            => 'try(:assignee).try(:name)',
        'Date enquiry received' => 'created_at.strftime("%d-%m-%Y")',
        'Quote'                 => '(itineraries.any? ? "Y" : "N")',
        'Booking'               => '(try(:itineraries).map(&:itinerary_price).compact.any? ? "Y" : "N")',
        'Adv. campaign'         => '',
        'Destination'           => 'try(:destination).try(:name)',
      }
    end

end
