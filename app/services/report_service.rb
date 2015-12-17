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

  def self.generate_csv(entities, titles_methods)
    # titles_methods hash structure:
    # key: name of the field
    # value: method to call

    csv_string = CSV.generate do |csv|
      csv << titles_methods.keys
      entities.each do |obj|
        row = titles_methods.values.map { |method| obj.instance_eval(method) }
        csv << row
      end
    end
  end
end