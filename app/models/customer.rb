# == Schema Information
#
# Table name: customers
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  lead_id              :integer
#  assigned_to          :integer
#  reports_to           :integer
#  first_name           :string(64)       default(""), not null
#  last_name            :string(64)       default(""), not null
#  title                :string(64)
#  source               :string(32)
#  email                :string(64)
#  alt_email            :string(64)
#  phone                :string(32)
#  mobile               :string(32)
#  fax                  :string(32)
#  blog                 :string(128)
#  linkedin             :string(128)
#  facebook             :string(128)
#  twitter              :string(128)
#  born_on              :date
#  do_not_call          :boolean          default("false"), not null
#  deleted_at           :datetime
#  background_info      :string(255)
#  skype                :string(128)
#  created_at           :datetime
#  updated_at           :datetime
#  issue_date           :date
#  expiry_date          :date
#  place_of_issue       :string(255)
#  passport_num         :string(255)
#  insurance            :string(255)
#  gender               :string(255)
#  emailID              :string(255)
#  xero_id              :string(255)
#  cust_sup             :string(255)
#  supplier_name        :string(255)
#  currency_id          :integer
#  num_days_payment_due :integer
#  after_hours_phone    :string(32)
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
                    format:     { with: VALID_EMAIL_REGEX_INCL_BLANK }, :allow_blank => true,
                    uniqueness: { case_sensitive: false }
  validates :phone,  length: { maximum: 32 }
  validates :mobile, length: { maximum: 32 }
  validates :fax, length: { maximum: 32 }
  validates :after_hours_phone, length: { maximum: 32 }
  validates :num_days_payment_due, numericality: true,  allow_blank: true
 

  
  belongs_to  :user
  belongs_to  :assignee, :class_name => "User", :foreign_key => :assigned_to
  has_many    :customer_enquiries, :dependent => :destroy
  has_many    :enquiries, -> { order("enquiries.id DESC")}, :through => :customer_enquiries
  has_one    :address, :as => :addressable
  accepts_nested_attributes_for :address
  has_many    :activities,  dependent: :destroy
  has_many    :bookings
  belongs_to     :currency

  has_many    :products, :foreign_key => "supplier_id"
  has_many    :template_infos, :foreign_key => "supplier_id"
  has_many    :itineraries
   
  has_paper_trail :ignore => [:created_at, :updated_at]
   
  before_save :default_values
   
  def default_values
    self.cust_sup ||= 'Customer'  # default to customer.
  end
  
  def getAddressDetails
    return  self.address.getDisplayString if !self.address.blank?
  end

  def fullname
    return "#{self.first_name} #{self.last_name}"
  end
  
  def dashboard_name
    "#{self.last_name}, #{self.first_name}"
  end
  
  def nice_id
    self.id.to_s.rjust(6, '0')
  end
  
  def create_email_link
    if Rails.env.development? || Rails.env.test?
      return self.emailID  + "@sandbox1a01ac497f324e96a84c07bc4d5bb5dd.mailgun.org"
    elsif Rails.env.production?
      return self.emailID  + "@app24117064.mailgun.org"
    end
  end
  
  def assigned_to_name
    if !self.assignee.nil?
      return self.assignee.name
    end
  end
  
  def initialize(*args)
     super(*args)
     self.emailID = SecureRandom.urlsafe_base64
  end
  
  def getCustomerShowPath
    if self.cust_sup == "Supplier"
      return supplier_path self
    elsif self.cust_sup == "Agent"
      return supplier_path self
    else
      return customer_path self
    end
  end
  
  def isSupplier?
    if self.cust_sup == "Supplier"
      return true
    else
      return false
    end
  end
  
  def isAgent?
    if self.cust_sup == "Agent"
      return true
    else
      return false
    end
  end
  
  def getSupplierCurrencySelect2
    if !self.cust_sup == "Supplier"
      return "";
    else
      if self.currency.blank?
        return "";
      else
        return self.currency.id.to_s + ":" + self.currency.code + " - " + self.currency.currency
      end
    end
  end
  
  def getSupplierCurrencyDisplay
    if !self.cust_sup == "Supplier"
      return "";
    else
      if self.currency.blank?
        return "No default currency set";
      else
        return self.currency.code + " - " + self.currency.currency
      end
    end
  end
  
end
