class ItineraryCloneService
  def self.clone(params, current_user)
    original_itinerary = Itinerary.where(id: params[:id]).first
    enquiry = Enquiry.where(id: params[:enquiry_id]).first

    return nil unless 
      original_itinerary.present? && 
      enquiry.present? &&
      params[:start_date].present? && 
      params[:old_date].present? &&
      current_user.present?

    start_date = params[:start_date].to_date
    old_date = params[:old_date].to_date

    enquiry_changed = (params[:enquiry_id] != params[:current_enquiry_id])

    itinerary_copy = make_copy(
      original_itinerary,
      enquiry,
      start_date,
      old_date,
      current_user
    )

    if enquiry_changed && itinerary_copy.present?
      enquiry.update_attributes(stage: 'Itinerary')
    end

    itinerary_copy
  end

  private

  def self.make_copy(original_itinerary, enquiry, start_date, old_date, current_user)
    days_between = (start_date - old_date).to_i
    itinerary_copy = original_itinerary.deep_clone include: [:itinerary_infos]

    itinerary_copy.name = original_itinerary.name + ' COPY'
    itinerary_copy.start_date = start_date
    
    itinerary_copy.status = "In Progress"
    itinerary_copy.user = current_user
    itinerary_copy.enquiry = enquiry # default if not selected

    itinerary_copy.customers = enquiry.customers
    itinerary_copy.agent = enquiry.agent
    itinerary_copy.lead_customer = enquiry.lead_customer
    itinerary_copy.num_passengers = enquiry.num_people

    if days_between != 0 && itinerary_copy.itinerary_infos.present?
      itinerary_copy.itinerary_infos.each do |info|
        info.start_date, info.end_date = 
          shift_dates(info.start_date, info.end_date, days_between)
      end
    end
    itinerary_copy
  end

  def self.shift_dates(info_start_date, info_end_date, days_to_shift)
    [info_start_date, info_end_date].map do |date| 
      (date + days_to_shift) if date.present?
    end
  end
end