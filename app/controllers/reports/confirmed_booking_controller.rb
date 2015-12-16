class Reports::ConfirmedBookingController < ApplicationController

  def index
    if params[:reports_search]
      @from = params[:reports_search][:from]    if params[:reports_search][:from].presence
      @to   = params[:reports_search][:to]      if params[:reports_search][:to].presence
      @user = params[:reports_search][:user_id] if params[:reports_search][:user_id].presence
    end

    search_params = {}
    search_params[:created_at]  = (@from && @to) ? (@from.to_date..@to.to_date.end_of_day) : (1.month.ago..Date.today.end_of_day)
    # ItineraryPrice.joins(:itinerary).where(created_at: (1.month.ago..Date.tomorrow)).where( :itinerary => { user_id: 2 } ) # WTF

    @users = User.where.not(name: "System")
    @itinerary_prices = ItineraryPrice
                          .includes(:itinerary)
                          .where(search_params)
                          .map { |it_price| it_price if @user ? (@user && it_price.itinerary.user.id == @user.to_i) : true } # UPDATE THIS
                          .compact

    respond_to do |format|
      format.html
      format.csv do
        attributes  = [ "Booking ID",
                        "Booking Name",
                        "Customer name",
                        "Consultant",
                        "Sale Value",
                        "Profit amount",
                        "Agent" ]

        csv_string = CSV.generate do |csv|
          csv << attributes
          @itinerary_prices.each do |it_price|
            row = [ it_price.id,
                    it_price.try(:itinerary).try(:name),
                    it_price.try(:itinerary).try(:lead_customer).try(:fullname_with_title),
                    it_price.try(:itinerary).try(:user).try(:name),
                    it_price.try(:sale_total).try(:to_s),
                    it_price.try(:get_total_supplier_profit),
                    it_price.try(:itinerary).try(:agent).try(:supplier_name) ]
            csv << row
          end
        end
        send_data csv_string
      end
      format.xls
    end
  end

end
