class RemindersController < ApplicationController
  authorize_resource class: RemindersController

  def index
    @open_enquiries = Enquiry.open_enquiries(current_user)

    respond_to do |format|
      format.html
    end
  end

  def dismiss
    dsm = params[:dismiss_until]
    type, id, str_date, note = dsm[:type], dsm[:id], dsm[:date], dsm[:note]
    @object = case type
      when 'Enquiry'
        Enquiry.where(id: id).first
      when 'Itinerary'
        Itinerary.where(id: id).first
      end
    
    if @object.present?
      @object.update_attribute(:dismissed_until, str_date.to_date) 
      flash[:success] = "#{type} dismissed until #{str_date}."
    else
      flash[:error] = "Error while dismissing"
    end
    
    redirect_to reminders_path
  end
end