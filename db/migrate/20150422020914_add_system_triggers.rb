class AddSystemTriggers < ActiveRecord::Migration

  def self.up
    Trigger.create!(:name => 'New Enquiry' , :setting_id => '1' )
    Trigger.create!(:name => 'New Booking' , :setting_id => '1' )
    Trigger.create!(:name => 'Confirmed Booking' , :setting_id => '1' )
    Trigger.create!(:name => 'Payment Recieved' , :setting_id => '1' )
    Trigger.create!(:name => 'Payment Failed' , :setting_id => '1' )
    Trigger.create!(:name => 'Deposit Due' , :setting_id => '1' )
    Trigger.create!(:name => 'Balance Due Soon' , :setting_id => '1' )
    Trigger.create!(:name => 'Balance Due' , :setting_id => '1' )
    Trigger.create!(:name => 'Balance Overdue' , :setting_id => '1' )
    Trigger.create!(:name => 'Pre-trip' , :setting_id => '1' )
    Trigger.create!(:name => 'Mid-trip' , :setting_id => '1' )
    Trigger.create!(:name => 'Post-trip' , :setting_id => '1' )
    Trigger.create!(:name => 'Trip Anniversary' , :setting_id => '1' )
    Trigger.create!(:name => 'Enquiry Follow Up' , :setting_id => '1' )
  end

end
