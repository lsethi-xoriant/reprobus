class RenameTableCustomerInteractionsToBookingHistory < ActiveRecord::Migration
  def change
    rename_table :customer_interactions, :booking_histories
  end
end
