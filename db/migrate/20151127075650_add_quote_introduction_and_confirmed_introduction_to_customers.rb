class AddQuoteIntroductionAndConfirmedIntroductionToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :quote_introduction, :text
    add_column :customers, :confirmed_introduction, :text
  end
end
