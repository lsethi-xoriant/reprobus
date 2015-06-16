class SupplierDatatable < AjaxDatatablesRails::Base
  def_delegators :@view, :link_to, :h, :supplier_path, :edit_supplier_path

  include AjaxDatatablesRails::Extensions::WillPaginate


  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(Customer.supplier_name Customer.first_name Customer.last_name Customer.email Customer.phone)

  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(Customer.supplier_name Customer.first_name Customer.last_name Customer.email Customer.phone)

  end

  private

  def data
    records.map do |record|
      [
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
        record.supplier_name, record.first_name, record.last_name, record.email,
        record.phone,
        link_to("<i class='mdi-image-edit'></i>".html_safe, edit_supplier_path(record), class: "btn-floating waves-effect waves-light pink")
      ]
    end
  end

  def get_raw_records
    # insert query here
    Customer.where(cust_sup: "Supplier")
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
