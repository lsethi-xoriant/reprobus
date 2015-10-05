class ItineraryTemplateDatatable < AjaxDatatablesRails::Base
  def_delegators :@view, :link_to, :h, :itinerary_template_path, :edit_itinerary_template_path
  
  include AjaxDatatablesRails::Extensions::Kaminari
  
  
  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(ItineraryTemplate.name ItineraryTemplate.created_at ItineraryTemplate.updated_at)

  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(ItineraryTemplate.name ItineraryTemplate.created_at ItineraryTemplate.updated_at)
  end

  private

  def data
    records.map do |record|
      [
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
        record.name,
        record.created_at.strftime("%d/%m/%Y"),
        record.updated_at.strftime("%d/%m/%Y"),
        record.itinerary_template_infos.count,
        link_to("<i class='mdi-image-edit small'></i>".html_safe, edit_itinerary_template_path(record), class: "btn-floating waves-effect waves-light green")
      ]
    end
  end

  def get_raw_records
    # insert query here
    ItineraryTemplate.all
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
