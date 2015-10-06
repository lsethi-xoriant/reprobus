class AddImageToAgent < ActiveRecord::Migration
  def change
    add_column :customers, :company_logo_id, :integer
  end
end
