# == Schema Information
#
# Table name: enquiries
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  assigned_to      :integer
#  name             :string(64)       default(""), not null
#  access           :string(8)        default("Public")
#  source           :string(32)
#  stage            :string(32)
#  probability      :integer
#  amount           :decimal(12, 2)
#  discount         :decimal(12, 2)
#  closes_on        :date
#  deleted_at       :datetime
#  background_info  :string(255)
#  subscribed_users :text
#  created_at       :datetime
#  updated_at       :datetime
#

class Enquiry < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 64 }
  validates :source, presence: true, length: { maximum: 32 }  
  validates :stage, presence: true, length: { maximum: 32 }
  validates :probability, presence: true, :inclusion => { :in => (1..100) , :message => "Must be in range of 1-100" }
  validates :user_id, presence: true
  
  belongs_to  :user
  belongs_to  :assignee, :class_name => "User", :foreign_key => :assigned_to
  has_many    :customer_enquiries, :dependent => :destroy
  has_many    :customers, :through => :customer_enquiries, :uniq => true, :order => "customers.id DESC"
  
  def created_by_name
    self.user.name
    #User.find(self.user_id).name
  end  
  
  def assigned_to_name
    if self.assigned_to 
      User.find(self.assigned_to).name
    end
  end
  
  def add_customer(customer)
    self.customers << customer unless customer.nil?
  end  
  
end
