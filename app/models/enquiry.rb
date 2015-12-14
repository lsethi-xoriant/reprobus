# == Schema Information
#
# Table name: enquiries
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  assigned_to        :integer
#  name               :string(64)       default(""), not null
#  access             :string(8)        default("Public")
#  source             :string(32)
#  stage              :string(32)
#  probability        :string(255)
#  amount             :decimal(12, 2)   default("0.0"), not null
#  discount           :decimal(12, 2)   default("0.0"), not null
#  closes_on          :date
#  deleted_at         :datetime
#  background_info    :string(255)
#  subscribed_users   :text
#  created_at         :datetime
#  updated_at         :datetime
#  duration           :string(255)
#  est_date           :date
#  num_people         :string(255)
#  percent            :integer
#  fin_date           :date
#  standard           :string(255)
#  insurance          :boolean
#  reminder           :date
#  xero_id            :string(255)
#  xpayments          :text
#  agent_id           :integer
#  lead_customer_id   :integer
#  lead_customer_name :string
#

class Enquiry < ActiveRecord::Base
  include CustomerRelation

  validates :name, presence: true, length: { maximum: 64 }
  #validates :source, presence: true, length: { maximum: 32 }
  validates :stage, presence: true, length: { maximum: 32 }
  validates :num_people, allow_nil: true,  numericality: { only_integer: true }, allow_blank: true
  validates :amount, numericality: true,  allow_blank: true
  validates :discount, numericality: true,  allow_blank: true
#  validates :probability, presence: true, :inclusion => { :in => (1..100) , :message => "Must be in range of 1-100" }
  validates :user_id, presence: true
#  validates :percent, presence: true, :inclusion => { :in => (0..100) , :message => "Must be in range of 0-100" }
#  validate :check_lead_customer_has_phone_email

  has_and_belongs_to_many  :carriers
  has_and_belongs_to_many  :destinations
  has_and_belongs_to_many  :stopovers

  belongs_to :destination
  
  serialize :xpayments
  
  scope :new_enquirires, -> { where(stage: 'New Enquiry') }
  scope :open, -> { where(stage: 'Open') }
  scope :in_progress, -> { where(stage: 'In Progress') }
  scope :bookings, -> { where(stage: 'Booking') }
  scope :is_itinerary, -> { where(stage: 'Itinerary') }
  scope :active, -> {where(:stage => ['In Progress', 'Open', 'New Enquiry'])}
  
  scope :active_plus_this_id, -> (id=0) { 
    where("id = :id OR stage IN (:active_stages)",
      id: id,
      active_stages: ['In Progress', 'Open', 'New Enquiry'])
  }
 # scope :notClosed, -> {where('stage != "Closed"') }
  
  belongs_to  :user
  belongs_to  :assignee, :class_name => "User", :foreign_key => :assigned_to
 
#  has_many    :customers_enquiries
 # has_many    :customers, -> { order("customers.id ASC") }, through: :customers_enquiries
  has_and_belongs_to_many :customers
  accepts_nested_attributes_for :customers, allow_destroy: true
  validates_associated :customers
  
  has_many    :activities,  dependent: :destroy
  has_one     :booking
  has_many    :itineraries
  belongs_to  :agent, :class_name => "Customer", :foreign_key => :agent_id
  belongs_to  :lead_customer, :class_name => "Customer", :foreign_key => :lead_customer_id
  
  after_save  :set_lead

  has_paper_trail :ignore => [:created_at, :updated_at], :meta => { :customer_names  => :customer_names }

  #def check_lead_customer_has_phone_email
  #  if self.lead_customer && (self.lead_customer.phone.blank? && self.lead_customer.email.blank?) then
  #    errors.add(:lead_customer, "must have phone or email")
  #  end
  #end

  def isActive
    return stage == "Open" || stage == "In Progress"
  end
  
  def convert_to_booking!(user)
    book = self.build_booking(name: self.name, amount: self.amount, status: "New Booking")
    book.user = user
    book.customer = self.lead_customer
    book.enquiry = self
    if book.save
      act = self.activities.create(type: "Converted", description: "Enquiry converted to Booking")
      if act
       user.activities<<(act)
      end
      self.update_attribute(:stage, "Booking")
      
      Trigger.trigger_new_booking(book)
      
      return true
    else
      return false
    end
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
    self.assigned_to ? str = str + self.assigned_to_name : str = str + "UNASSIGNED"
    self.customers.count > 0 ? str = str + " | " + self.dasboard_customer_name : str = str + " | NO CUSTOMER"
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

end
