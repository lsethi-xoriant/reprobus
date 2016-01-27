class RemindersController < ApplicationController
  authorize_resource class: RemindersController

  def index
    @open_enquiries = Enquiry.all
    respond_to do |format|
      format.html
    end
  end
end