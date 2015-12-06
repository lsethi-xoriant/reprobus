class AddConfirmationFieldsToCountry < ActiveRecord::Migration
  def change
    add_column :countries, :visa_details, :text
    add_column :countries, :warnings, :text
    add_column :countries, :vaccinations, :text
  end
end
