class ReportService

  def self.prepare_dates(from=nil, to=nil)
    from = 1.month.ago unless from.present?
    to   = Date.today unless to.present?
    [from.to_date.beginning_of_day, to.to_date.end_of_day]
  end

  def self.booking_travel_search(from, to, user=nil, country=nil)
    results = 
        Itinerary.includes(:lead_customer, :agent, itinerary_infos: :product)
        .joins(:itinerary_price)
        .eager_load(itinerary_infos: :product)
        .where(itinerary_prices: { booking_confirmed: true })
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

  def self.confirmed_booking(from, to, user=nil, confirmed_itinerary_sent = nil)
    search_params = {}
    search_params[:booking_confirmed_date] = (from && to) ? (from.to_date.beginning_of_day..to.to_date.end_of_day) : (1.month.ago.beginning_of_day..Date.today.end_of_day)
    search_params[:booking_confirmed]      = true
    if user
      search_params[:itineraries] = {}
      search_params[:itineraries][:user_id] = user
    end

    results = ItineraryPrice
                .includes(:itinerary)
                .joins(:itinerary)
                .where(search_params)

    case confirmed_itinerary_sent
    when 'true'
      results = 
        results.where.not(itineraries: {confirmed_itinerary_sent: nil })
    when 'false'
      results = 
        results.where(itineraries: {confirmed_itinerary_sent: nil })
    end
    results
  end

  def self.supplier_search(from, to, search_by, supplier=nil)
    # Commented code is another way of doing the same thing.
    # Please remove once the task is resolved.

    # results = 
    #   ItineraryPrice
    #     .joins(:itinerary, :supplier_itinerary_price_items)
    #     .where(customer_invoice_sent: true)
    #     .includes(itinerary: :lead_customer)

    # results = 
    #   case search_by
    #   when 'confirmed_date'
    #     results.where(booking_confirmed_date: from..to)
    #   when 'travel_date'
    #     results.where('itineraries.start_date': from..to)
    #   else
    #     results
    #   end

    # if supplier.present?
    #   results = results.where(itinerary_price_items: { supplier_id: supplier} )
    # end

    # if results.present? 
    #   results.map(&:supplier_itinerary_price_items)
    # else
    #   ItineraryPriceItem.none
    # end

    results = 
      ItineraryPriceItem
        .joins(:supplier_itinerary_price)
        .joins(supplier_itinerary_price: :itinerary)
        .where(itinerary_prices: { customer_invoice_sent: true })

    results = 
      case search_by
      when 'confirmed_date'
        results
          .where(itinerary_prices: { booking_confirmed_date: from..to })
      when 'travel_date'
        results.where(itineraries: { start_date: from..to })
      else
        results
      end

    if supplier.present?
      results = results.where(supplier_id: supplier)
    end

    results
      .includes(:supplier)
      .includes(:supplier_itinerary_price)
      .includes(supplier_itinerary_price: :itinerary)
      .includes(supplier_itinerary_price: { itinerary: :lead_customer })

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
