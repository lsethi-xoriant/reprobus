class Reports::EnquiriesController < ApplicationController

  def index
    if params[:reports_search]
      @from, @to   = params[:reports_search][:from], params[:reports_search][:to]
      @stage       = params[:reports_search][:stage]
                      .map {|prm| prm[0] if prm[1] == "1"} ## Warning. This map needed for collect values from checkboxes form
                      .compact                             ## value == "1" mean checked, value == "0" mean unchecked
      stage        = @stage.any? ? @stage : Enquiry::STATUSES   ## If there is no values we choose all statuses by default
      @assigned_to = params[:reports_search][:assigned_to_id]
    end
    @enquiries =
      if @from && @to
        Enquiry
         .includes(:destination, itineraries: [:itinerary_price])
         .where(created_at: (@from..@to),
                stage: stage,
                assigned_to: @assigned_to)
      else
        Enquiry
         .includes(:destination, itineraries: [:itinerary_price])
         .all
      end

    respond_to do |format|
      format.html
      format.csv do
        attributes  = [ "Id",
                        "Enquiry name",
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
