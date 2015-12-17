class ReportService
  def self.booking_travel_search(from, to, user=nil, country=nil)
    results = 
        Itinerary.includes(:lead_customer, :agent, itinerary_infos: :product)
        .eager_load(itinerary_infos: :product)
        .where('? < itineraries.end_date AND ? > itineraries.start_date', from, to)

    results = results.where(user_id: user) if user.present?

    if country.present?
      results = 
        results.where('products.country_id = :country_id', country_id: country)
    end
    results
  end

  def self.enquiry_search(from, to, stage, assigned_to)
    search_params = {}
    search_params[:created_at]  = (from && to) ? (from.to_date.beginning_of_day..to.to_date.end_of_day) : (1.month.ago.beginning_of_day..Date.today.end_of_day)
    search_params[:stage]       = stage if stage.presence
    search_params[:assigned_to] = assigned_to if assigned_to.presence

    results = Enquiry
              .includes(:destination, itineraries: [:itinerary_price])
              .where(search_params)
  end

  def self.confirmed_booking(from, to, user=nil)
    search_params = {}
    search_params[:booking_confirmed_date] = (from && to) ? (from.to_date.beginning_of_day..to.to_date.end_of_day) : (1.month.ago.beginning_of_day..Date.today.end_of_day)
    search_params[:booking_confirmed]      = true
    if user
      search_params[:itineraries] = {}
      search_params[:itineraries][:user_id] = user
    end

    results = ItineraryPrice
                .includes(:itinerary)
                .where(search_params)
  end

  def self.generate_csv(entities, titles_methods)
    # titles_methods hash structure:
    # key: name of the field
    # value: method to call

    csv_string = CSV.generate do |csv|
      csv << titles_methods.keys
      entities.each do |obj|
        row = titles_methods.values.map do |method| 
          obj.instance_eval(method) if method.present?
        end
        csv << row
      end
    end
  end
end
