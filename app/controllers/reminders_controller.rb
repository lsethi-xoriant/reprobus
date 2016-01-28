class RemindersController < ApplicationController
  authorize_resource class: RemindersController

  def index
    @open_enquiries = Enquiry.open_enquiries(current_user)

    respond_to do |format|
      format.html
    end
  end

  def dismiss
    if RemindersService.record_dismission(params, current_user)
      type = params[:dismiss_until][:type]
      str_date = params[:dismiss_until][:date]
      flash[:success] = "#{type} dismissed until #{str_date}."
    else
      flash[:error] = "Error while dismissing"
    end

    redirect_to reminders_path
  end

  def lost
    if RemindersService.mark_as_lost(params)
      flash[:success] = "#{params[:type]} marked as Lost." 
    else
      flash[:error] = "Error while marking as Lost"
    end
    redirect_to reminders_path
  end

end