class EnquiryDatatable < AjaxDatatablesRails::Base
  def_delegators :@view, :link_to, :h, :enquiry_path, :edit_enquiry_path, :get_status_color

  include AjaxDatatablesRails::Extensions::Kaminari

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(Enquiry.name Enquiry.lead_customer_name Customer.email Customer.phone Enquiry.created_at Enquiry.amount Enquiry.stage User.name)

  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(Enquiry.name Enquiry.lead_customer_name Customer.email Customer.phone Enquiry.created_at Enquiry.amount Enquiry.stage User.name)

  end

  private

  def data
    records.map do |record|
      [
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
        record.name,
        link_to(record.lead_customer_name, record.lead_customer),
        record.lead_customer.email,
        record.lead_customer.phone,
        record.created_at.strftime("%d/%m/%Y"),
        record.amount,
        "<span class='" + get_status_color(record.stage) + "'>" + record.stage.upcase + "</span>",
        record.assigned_to_name,
        link_to("<i class='mdi-image-edit small'></i>".html_safe, edit_enquiry_path(record), class: "btn-floating waves-effect waves-light green")
      ]
    end
  end

  def get_raw_records
    # insert query here
    #Enquiry.joins(:lead_customer, :assignee).active  #needed to add left join below incase no user assigned. can do same thing for lead cust etc. 
    Enquiry.joins(:lead_customer).joins("LEFT OUTER JOIN users ON users.id = enquiries.assigned_to").active
  end

  # ==== Insert 'presenter'-like methods below if necessary
end