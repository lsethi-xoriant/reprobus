class AddMiscStuffToSupplier < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string    :code
      t.string    :currency
      t.timestamps
    end
    
    add_column :customers, :currency_id, :integer
    add_column :invoices, :currency_id, :integer
  end
end
