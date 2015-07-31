class ProductDatatable < AjaxDatatablesRails::Base
  def_delegators :@view, :link_to, :h, :product_path, :edit_product_path, :get_edit_path

  include AjaxDatatablesRails::Extensions::Kaminari


  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(Product.name Product.destination_search Product.country_search)

  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(Product.name Product.destination_search Product.country_search)

  end

  private

  def data
    records.map do |record|
      [
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
        record.name, 
        record.destination_search, 
        record.country_search, 
        record.supplierNames,
        link_to("<i class='mdi-image-edit'></i>".html_safe, get_edit_path(record), class: "btn-floating waves-effect waves-light blue")
      ]
    end
  end

  def get_raw_records
    # insert query here
    Product.includes(:suppliers).where(type: options[:type])
  end
end