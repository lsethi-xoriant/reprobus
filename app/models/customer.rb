# == Schema Information
#
# Table name: customers
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  lead_id         :integer
#  assigned_to     :integer
#  reports_to      :integer
#  first_name      :string(64)       default(""), not null
#  last_name       :string(64)       default(""), not null
#  title           :string(64)
#  source          :string(32)
#  email           :string(64)
#  alt_email       :string(64)
#  phone           :string(32)
#  mobile          :string(32)
#  fax             :string(32)
#  blog            :string(128)
#  linkedin        :string(128)
#  facebook        :string(128)
#  twitter         :string(128)
#  born_on         :date
#  do_not_call     :boolean          default(FALSE), not null
#  deleted_at      :datetime
#  background_info :string(255)
#  skype           :string(128)
#  created_at      :datetime
#  updated_at      :datetime
#

class Customer < ActiveRecord::Base
  validates :first_name, presence: true, length: { maximum: 64 }
  validates :last_name, presence: true, length: { maximum: 64 }  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false } 
  VALID_EMAIL_REGEX_INCL_BLANK = /\A^$|[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :alt_email, presense: false,
                    format:     { with: VALID_EMAIL_REGEX_INCL_BLANK },
                    uniqueness: { case_sensitive: false }   
  validates :phone,  length: { maximum: 32 }    
  validates :mobile, length: { maximum: 32 }  
  validates :fax, length: { maximum: 32 }  
  
  belongs_to  :user
  belongs_to  :assignee, :class_name => "User", :foreign_key => :assigned_to
  has_many    :customer_enquiries, :dependent => :destroy
  has_many    :enquiries, :through => :customer_enquiries, :uniq => true, :order => "enquiries.id DESC"
end
