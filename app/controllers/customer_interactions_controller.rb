class CustomerInteractionsController < ApplicationController
  before_filter :signed_in_user
  def download
    url = CustomerInteraction.find(params[:id]).try(:attachment).try(:url)
    return unless url.present?
    data = open(url)
    send_data data.read, :type => data.content_type, :x_sendfile => true
  end
end