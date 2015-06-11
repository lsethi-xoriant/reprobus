class EnquiryDatatable < AjaxDatatablesRails::Base
  def_delegators :@view, :link_to, :h, :enquiry_path, :edit_enquiry_path, :get_status_color

  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(Enquiry.name Enquiry.created_at Enquiry.stage)

  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(Enquiry.name Enquiry.created_at Enquiry.stage)

  end

  private

  def data
    records.map do |record|
      [
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
        record.name, record.dasboard_customer_name, record.customer_email, record.created_at,
        record.customer_phone, record.assigned_to_name, "<span class='" + get_status_color(record.stage) + "'>" + record.stage.upcase + "</span>",
        link_to("<i class='mdi-image-edit'></i>".html_safe, edit_enquiry_path(record), class: "btn-floating waves-effect waves-light pink")
      ]
    end
  end

  def get_raw_records
    # insert query here
    Enquiry.all
  end

  # ==== Insert 'presenter'-like methods below if necessary
end