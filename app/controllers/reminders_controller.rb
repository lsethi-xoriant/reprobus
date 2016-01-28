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
    type, id, str_date, note = dsm[:type], params[:id], dsm[:date], dsm[:note]
    @object = find_object(type, id)
    
    if @object.present?
      @object.update_attribute(:dismissed_until, str_date.to_date) 
      flash[:success] = "#{type} dismissed until #{str_date}."
    else
      flash[:error] = "Error while dismissing"
    end

    # TODO: add note to DB
    
    redirect_to reminders_path
  end

  def lost
    @object = find_object(params[:type], params[:id])
    if @object.present?
      @object.update_attribute(:stage, 'Dead') 
      flash[:success] = "#{params[:type]} marked as Lost." 
    else
      flash[:error] = "Error while marking as Lost"
    end
    redirect_to reminders_path
  end

  private

    def find_object(type, id)
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