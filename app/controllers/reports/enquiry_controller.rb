class Reports::EnquiryController < ApplicationController

  def index
    if params[:reports_search]
      @from        = params[:reports_search][:from] if params[:reports_search][:from].presence
      @to          = params[:reports_search][:to]   if params[:reports_search][:to].presence
      @stage       = params[:reports_search][:stage]
                      .map {|prm| prm[0] if prm[1] == "1"} ## Warning. This map needed for collect values from checkboxes form
                      .compact                             ## value == "1" mean checked, value == "0" mean unchecked
      stage        = @stage.any? ? @stage : Enquiry::STATUSES ## If there is no values we choose all statuses by default
      @assigned_to = params[:reports_search][:assigned_to_id]
    end

    search_params = {}
    search_params[:created_at]  = (@from && @to) ? (@from.to_date..@to.to_date.end_of_day) : (1.month.ago..Date.today.end_of_day)
    search_params[:stage]       = stage if stage
    search_params[:assigned_to] = @assigned_to if @assigned_to.presence

    @enquiries = Enquiry
                  .includes(:destination, itineraries: [:itinerary_price])
                  .where(search_params)

    respond_to do |format|
      format.html
      format.csv do
        attributes  = [ "Id",
                        "Enquiry name",
                        "Status",
                        "Customer name",
                        "Consultant",
                        "Date enquiry received",
                        "Quote",
                        "Booking",
                        "Adv. campaign",
                        "Destination" ]

        csv_string = CSV.generate do |csv|
          csv << attributes
          @enquiries.each do |enq|
            row = [ enq.id,
                    enq.name,
                    enq.stage,
                    enq.try(:lead_customer).try(:fullname),
                    enq.try(:assignee).try(:name),
                    enq.created_at.strftime("%d-%m-%Y"),
                    (enq.itineraries.any? ? "Y" : "N"),
                    (enq.try(:itineraries).map(&:itinerary_price).compact.any? ? "Y" : "N"),
                    "",
                    enq.try(:destination).try(:name) ]
            csv << row
          end
        end
        send_data csv_string
      end
      format.xls
    end
  end

end
