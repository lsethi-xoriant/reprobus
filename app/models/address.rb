# == Schema Information
#
# Table name: addresses
#
#  id               :integer          not null, primary key
#  street1          :string(255)
#  street2          :string(255)
#  city             :string(64)
#  state            :string(64)
#  zipcode          :string(16)
#  country          :string(64)
#  full_address     :string(255)
#  address_type     :string(16)
#  addressable_id   :integer
#  addressable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  deleted_at       :datetime
#

class Address < ActiveRecord::Base
  belongs_to :addressable, :polymorphic => true
  
  
  def reject_address(attributes)
    exists = attributes['id'].present?
    empty = %w(street1 street2 city state zipcode country full_address).map{|name| attributes[name].blank?}.all?
    attributes.merge!({:_destroy => 1}) if exists and empty
    return (!exists and empty)
  end
  
  def getDisplayString
     [self.street1, self.street2, self.city, self.state, self.zipcode, self.country].select{|line| !(line.nil? or line.empty?)}.join("\n")
  end
end
