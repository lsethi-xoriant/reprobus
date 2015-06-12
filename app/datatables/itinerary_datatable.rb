class ItineraryDatatable < AjaxDatatablesRails::Base
  def_delegators :@view, :link_to, :h, :itinerary_path, :edit_itinerary_path, :get_status_color
  
  include AjaxDatatablesRails::Extensions::WillPaginate
  
  
  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(Itinerary.name Enquiry.lead_customer_name Itinerary.created_at Itinerary.updated_at User.name)

  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(Itinerary.name Enquiry.lead_customer_name Itinerary.created_at Itinerary.updated_at User.name)
  end

  private

  def data
    records.map do |record|
      [
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
        record.name,
        record.enquiry.lead_customer_name,
        record.created_at.strftime("%d/%m/%Y"),
        record.updated_at.strftime("%d/%m/%Y"),
        record.user.name,
        record.itinerary_infos.count,
        "<span class='" + get_status_color(record.status) + "'>" + record.status.upcase + "</span>",
        link_to("<i class='mdi-image-edit small'></i>".html_safe, edit_itinerary_path(record), class: "btn-floating waves-effect waves-light green")
      ]
    end
  end

  def get_raw_records
    # insert query here
    Itinerary.joins(:enquiry, :user).all
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
