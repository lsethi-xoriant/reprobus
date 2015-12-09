class ItineraryCloneService
  def self.clone(params)
    original_itinerary = Itinerary.where(id: params[:id]).first
    enquiry = Enquiry.where(id: params[:enquiry_id]).first

    return nil unless 
      original_itinerary.present? && 
      enquiry.present? &&
      params[:start_date].present? && 
      params[:old_date].present? &&

    start_date = params[:start_date].to_date
    old_date = params[:old_date].to_date

    make_copy(original_itinerary, enquiry, start_date, old_date)
  end

  private

  def self.make_copy(original_itinerary, enquiry, start_date, old_date)
    days_between = (start_date - old_date).to_i
    itinerary_copy = original_itinerary.deep_clone include: [:itinerary_infos]

    itinerary_copy.name = original_itinerary.name + ' COPY'
    itinerary_copy.start_date = start_date
    itinerary_copy.enquiry = enquiry

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