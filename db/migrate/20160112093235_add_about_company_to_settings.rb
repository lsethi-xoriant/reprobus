class AddAboutCompanyToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :about_company, :text
  end
end
