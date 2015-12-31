class AddNationalityToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :nationality, :string
  end
end
