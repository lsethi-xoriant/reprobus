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
  attr_accessor :lead_customer
  
  validates :first_name, presence: true, length: { maximum: 64 }
  validates :last_name, length: { maximum: 64 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   false,
                    format:     { with: VALID_EMAIL_REGEX }, :allow_blank => true,
                    uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX_INCL_BLANK = /\A^$|[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :alt_email, presense: false,
                    format:     { with: VALID_EMAIL_REGEX_INCL_BLANK }, :allow_blank => true,
                    uniqueness: { case_sensitive: false }
  validates :phone,  length: { maximum: 255 }
  validates :mobile, length: { maximum: 32 }
  validates :fax, length: { maximum: 32 }
  validates :after_hours_phone, length: { maximum: 255 }
  validates :num_days_payment_due, numericality: true,  allow_blank: true
  
  validates :supplier_name, uniqueness: { case_sensitive: false },allow_blank: true
  
  
  belongs_to  :user
  belongs_to  :assignee, :class_name => "User", :foreign_key => :assigned_to
#  has_many    :customers_enquiries
 # has_many    :enquiries, -> { order("enquiries.id DESC")}, :through => :customers_enquiries
  has_and_belongs_to_many :enquiries
  accepts_nested_attributes_for :enquiries, allow_destroy: true;
  
  has_one    :address, :as => :addressable
  accepts_nested_attributes_for :address
  
  
  has_many    :activities,  dependent: :destroy
  has_many    :bookings
  belongs_to  :currency

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
      return self.currency.displayName if self.currency
    end
  end
 
 
  def self.importSupplier(file)
    require 'roo'
    
    spreadsheet = Admin.open_spreadsheet(file)
    header = spreadsheet.row(1)
    int = 0
    skip = 0
    val = 0
    errstr = ""
    returnStr = ""
    
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      
      if (find_by_email(row["EmailAddress"]) || find_by_supplier_name(row["SupplierName"]))
        skip = skip + 1 # trying to create a record that already exists with these details. skip it. 
        next
      end
      
      ent = new
      
      ent.cust_sup = "Supplier"
      str = (row["SupplierName"])
      ent.supplier_name = str
      
      if ent.new_record? || ent.address.nil?
        ent.build_address
      end
      
      str = (row["AddressLine1"])
      ent.address.street1 = str
      str = (row["AddressLine2"])
      ent.address.street2 = str
      str = (row["Suburb"])
      ent.address.city = str
      str = (row["Country"])
      ent.address.country = str      
      str = (row["Postcode"])
      ent.address.zipcode = str
      str = (row["ContactName"])
      str ||= ent.supplier_name
      ent.first_name = str      
      str = (row["PhoneNo"])
      ent.phone = str      
      str = (row["EmergencyPh"])
      ent.after_hours_phone = str  
      str = (row["EmailAddress"])
      ent.email = str  
      str = (row["Currency"])
      curr = Currency.find_by_code(str)
      ent.currency = curr             
      if !ent.save
        errstr = "<br>" + "Supplier: #{ent.supplier_name} has validation errors - #{ent.errors.full_messages}" + errstr 
        val = val + 1
        next
      end
      int = int + 1
      
    end
    
    returnStr = "<strong>Supplier Import</strong><br>" + 
                (spreadsheet.last_row - 1).to_s + " rows read.<br>" + int.to_s + " suppliers created.<br>" + 
                skip.to_s + " records skipped due to record already exists<br>" + 
                val.to_s + " Validation errors:"
    return returnStr + errstr;
  end     
end
