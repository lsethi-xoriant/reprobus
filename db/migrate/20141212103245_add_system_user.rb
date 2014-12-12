class AddSystemUser < ActiveRecord::Migration
  def self.up
    user = User.create!( :email => 'hamish@writecode.com.au', :name => 'System', :password => 'password', :password_confirmation => 'password' )
  end

  def self.down
    user = User.find_by_name( 'System' )
    user.destroy
  end
end
