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
#  stage            :string(32)       # this is lead status
#  probability      :string(255)
#  amount           :decimal(12, 2)
#  discount         :decimal(12, 2)
#  closes_on        :date
#  deleted_at       :datetime
#  background_info  :string(255)
#  subscribed_users :text
#  created_at       :datetime
#  updated_at       :datetime
#  duration         :string(255)
#  est_date         :date
#  num_people       :string(255)
#  percent          :integer
#  fin_date         :date
#  standard         :string(255)
#  insurance        :boolean
#  reminder         :date
#  destinations     :text
#  stopovers        :text
#  carriers         :text
#

class Enquiry < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 64 }
  validates :source, presence: true, length: { maximum: 32 }  
  validates :stage, presence: true, length: { maximum: 32 }
  validates :num_people, allow_nil: true,  numericality: { only_integer: true }, allow_blank: true  
  validates :amount, numericality: true,  allow_blank: true  
  validates :discount, numericality: true,  allow_blank: true  
#  validates :probability, presence: true, :inclusion => { :in => (1..100) , :message => "Must be in range of 1-100" }
  validates :user_id, presence: true
#  validates :percent, presence: true, :inclusion => { :in => (0..100) , :message => "Must be in range of 0-100" }

  #serialize :destinations
  #serialize :stopovers
  #serialize :carriers
  has_and_belongs_to_many  :carriers
  has_and_belongs_to_many  :destinations
  has_and_belongs_to_many  :stopovers
  
  scope :open, -> { where(stage: 'Open') }
  scope :in_progress, -> { where(stage: 'In Progress') }
  scope :bookings, -> { where(stage: 'Booking') }
 # scope :notClosed, -> {where('stage != "Closed"') }
  
  belongs_to  :user
  belongs_to  :assignee, :class_name => "User", :foreign_key => :assigned_to
  has_many    :customer_enquiries, :dependent => :destroy 
  has_many    :customers, :through => :customer_enquiries, :uniq => true, :order => "customers.id DESC"
  accepts_nested_attributes_for :customers, :allow_destroy => false; 
  has_many    :activities,  dependent: :destroy
  
  has_paper_trail :ignore => [:created_at, :updated_at], :meta => { :customer_names  => :customer_names}

  CONSUM_KEY = "SJXI8AQKB8GYBQSG9VLHJJ3QNJ13JV"
  OAUTH_SECRET_KEY = "T7K1GEBJZUZMUYA3PXQHIEXXMZRAJS"
  
  def add_customer(customer)
    self.customer_enquiries.create!(customer_id: customer.id) unless customer.nil?
    #self.customers << customer unless customer.nil?
  end  
  
  def created_by_name
    self.user.name
    #User.find(self.user_id).name
  end  
  
  def convert_to_booking!(user)
    self.stage = "Booking"
    self.save
    
    act = self.activities.create(type: "Booking", description: "Enquiry converted to Booking")
    if act
      user.activities<<(act)
    end
    
    errStr =  self.create_invoice_xero(user)
    
    return errStr
  end
  
  def create_invoice_xero(user)
    #talk to xero and create contact and invoice
    require 'rubygems'
    require 'xeroizer'

    path = Rails.root + "config/privatekey.pem"
    
    # Create client (used to communicate with the API).
    client = Xeroizer::PrivateApplication.new(CONSUM_KEY, OAUTH_SECRET_KEY, path)
    
    #if we have a lead customer create contact in xero if it does not already exist. 
    #self.customers.each do |cust| # xero only allows one contact per invoice. 
    cust = self.customers.first   
    xcontacts = client.Contact.all(:where => {:name => cust.fullname})
    if xcontacts.blank? && !cust.email.nil?
      # try match on email
      xcontacts = client.Contact.all(:where => {:email_address => cust.email})
    end

    if xcontacts.blank? 
      puts "HAMISH - no match"
      #add contact to xero
      xcust = client.Contact.build(:name => cust.fullname)
      xcust.first_name = cust.first_name
      xcust.last_name =  cust.last_name
      xcust.email_address = cust.email
      #xcust.add_address(:type => 'STREET', :line1 => '12 Testing Lane', :city => 'Brisbane') # TO BE ADDED
      #xcust.add_phone(:type => 'DEFAULT', :area_code => '07', :number => '3033 1234')  # TO BE ADDED
      xcust.add_phone(:type => 'MOBILE', :number => cust.mobile)  # ADD nomal phone - may need to structure our phone records like xero does. 
      xcust.save
    else
      xcust = xcontacts.first
    end
    
    xinv = client.Invoice.build({
      :type => "ACCREC",
      :status => "AUTHORISED",
      :date => Date.today,
      :due_date => (Date.today + 30),
      :line_items => [{
        :description => self.name,
        :quantity => 1,
        :unit_amount => self.amount,
        :account_code => 200
        }]
      })
    
    xinv.contact = xcust
    xinv.save
       
    act = self.activities.create(type: "Booking", description: "Invoice created in Xero")
    if act
      user.activities<<(act)
    end  

  end
  
  def assigned_to_name
    if self.assigned_to 
      User.find(self.assigned_to).name
    end
  end
  
  def dasboard_customer_name
    if !self.customers.empty? 
      self.customers.first.last_name + ", " + self.customers.first.first_name 
    else 
      "No Customer Details"
    end
  end
  
  def customer_names
    str = ""
    self.customers.each do |cust| 
      str = str + cust.first_name + " " + cust.last_name + ", " 
    end  
    return str.chomp(", ")
  end
  
  def customer_title
    self.customers.first.title unless self.customers.empty?
  end
  
  def customer_email
    self.customers.first.email unless self.customers.empty?
  end
  
  def customer_phone
    self.customers.first.phone unless self.customers.empty?
  end
  
  def carrier_names
    str = ""

    self.carriers.each do |car|
        str = str + car.name + "," 
    end
   return str.chomp(",")
  end
  
  
  def carriers_select2
    str = ""

    self.carriers.each do |car|
      str = str + car.id.to_s + ":" +car.name + "," 
    end
  
   return str.chomp(",")
  end  

  def destinations_select2
    str = ""

    self.destinations.each do |car|
      str = str + car.id.to_s + ":" +car.name + "," 
    end
  
   return str.chomp(",")
  end  
  
  def is_booking 
    return self.stage == "Booking"
  end
  
  def stopovers_select2
    str = ""

    self.stopovers.each do |car|
      str = str + car.id.to_s + ":" +car.name + "," 
    end
  
   return str.chomp(",")
  end    
 
  def stopover_names
    str = ""

    self.stopovers.each do |car|
        str = str + car.name + "," 
    end
   return str.chomp(",")
  end
  
  def destination_names
    str = ""

    self.destinations.each do |car|
        str = str + car.name + "," 
    end
   return str.chomp(",")
  end
  
  def enquiry_display_str
    str = "( "
    if self.assigned_to 
      str = str + self.assigned_to_name 
    else
      str = str + "UNASSIGNED" 
    end
    
    if self.customers.count > 0 then 
      str = str + " | " + self.dasboard_customer_name
    else
      str = str + " | NO CUSTOMER" 
    end
    str = str + " )"
  end
    
  def percent_complete
    if self.percent.nil? then 
      return "0"
    else
      return self.percent
    end  
  end
  
  def duration_in_days
    if !self.est_date.nil? && !self.fin_date.nil? 
      duration = (self.fin_date - self.est_date).to_i.to_s + " days" 
    end 
  end
    
  def get_first_customer_num
    num = self.customers.first.id unless self.customers.empty?
  end 
    
  def first_customer
    return self.customers.first unless self.customers.empty?
  end    
    
  def validate_new_customer(email, mobile)
    if !email.strip == ""
      cust = Customer.find_by_email(email)
      if !cust.nil?
        errors.add(:CustomerExists,"Customer already exists with this email: #{cust.fullname}")
      end
    end
    if mobile.strip == ""
      cust = Customer.find_by_mobile(mobile)
      if !cust.nil?
        errors.add(:CustomerExists,"Customer already exists with this mobile: #{cust.fullname}")
      end
    end
  end
end
