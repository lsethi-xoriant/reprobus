class Add < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.decimal   :amount, :precision => 12, :scale => 5
      t.string    :payment_ref
      t.belongs_to :invoice
      t.timestamps
    end
  end
end
