class RemindersController < ApplicationController
  authorize_resource class: RemindersController

  def index
    @open_enquiries = Enquiry.open_enquirires(current_user)

    respond_to do |format|
      format.html
    end
  end

  def dismiss
    @enquiry = Enquiry.find(params[:id])
    @enquiry.update_attribute(:dismissed_until, Date.tomorrow)
    flash[:success] = "Enquiry dismissed."
    redirect_to reminders_path
  end
end