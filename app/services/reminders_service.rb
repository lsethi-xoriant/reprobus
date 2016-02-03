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
      
      record_note(object, note, current_user)

      true
    else
      false
    end
  end

  def self.mark_as_lost(params, current_user)
    object = find_object(params[:type], params[:id])
    note = params[:note]
    if object.present?
      object.update_attribute(:stage, 'Dead')
      record_note(object, note, current_user)
      true
    else
      false
    end
  end

  private

    def self.record_note(object, note, current_user)
      return unless (note.present? && current_user.present?)
      act = object.activities.create(type: 'Note', description: note)
      current_user.activities<<(act) if act
    end

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