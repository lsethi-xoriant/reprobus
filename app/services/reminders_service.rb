class RemindersService
  def self.record_dismission(params, current_user)
    dsm = params[:dismiss_until]
    type, id, str_date, note = dsm[:type], params[:id], dsm[:date], dsm[:note]
    object = find_object(type, id)
    
    if object.present?
      object.update_attribute(:dismissed_until, str_date.to_date) 
      
      if str_date.to_date > (Date.today + 2.month)
        object.update_attribute(:stage, 'Long Term')
      end
      
      if note.present?
        act = object.activities.create(type: 'Note', description: note)
        current_user.activities<<(act) if act
      end
      true
    else
      false
    end
  end

  def self.mark_as_lost(params)
    object = find_object(params[:type], params[:id])
    if object.present?
      object.update_attribute(:stage, 'Dead') 
      true
    else
      false
    end
  end

  private

    def self.find_object(type, id)
      case type
        when 'Enquiry'
          Enquiry.where(id: id).first
        when 'Itinerary'
          Itinerary.where(id: id).first
        else
          nil
        end
    end
end