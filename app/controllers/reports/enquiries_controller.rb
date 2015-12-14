class Reports::EnquiriesController < ApplicationController

  def index
    @from, @to = params[:reports_search][:from], params[:reports_search][:to] if params[:reports_search]
    @enquiries =
      if @from && @to
        Enquiry
         .includes(:destination, itineraries: [:itinerary_price])
         .where(created_at: (@from..@to))
      else
        Enquiry
         .includes(:destination, itineraries: [:itinerary_price])
         .all
      end

    respond_to do |format|
      format.html
      format.csv do
        attributes  = [ "Id",
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
