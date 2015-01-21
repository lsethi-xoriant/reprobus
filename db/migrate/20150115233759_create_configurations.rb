class CreateConfigurations < ActiveRecord::Migration
  def change
    create_table :configurations do |t|
      t.string    :company_name
      t.string    :pxpay_user_id
      t.string    :pxpay_key
      t.boolean   :use_xero
      t.string    :xero_consumer_key
      t.string    :xero_consumer_secret
      t.timestamps
    end
  end
end
