class AddConfirmationFieldsToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :important_notes, :text
  end
end
