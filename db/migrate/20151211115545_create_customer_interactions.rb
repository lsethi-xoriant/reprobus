class CreateCustomerInteractions < ActiveRecord::Migration
  def change
    create_table :customer_interactions do |t|
      t.timestamp :emailed_at
      t.string :emailed_to
      t.integer :document_type
    end
  end
end
