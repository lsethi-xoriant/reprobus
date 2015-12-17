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
end