# == Schema Information
#
# Table name: itineraries
#
#  id                         :integer          not null, primary key
#  name                       :string
#  start_date                 :date
#  num_passengers             :integer
#  complete                   :boolean
#  sent                       :boolean
#  quality_check              :boolean
#  includes                   :text
#  excludes                   :text
#  notes                      :text
#  flight_reference           :string
#  user_id                    :integer
#  customer_id                :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#  itinerary_template_id      :integer
#  enquiry_id                 :integer
#  status                     :string
#  itinerary_default_image_id :integer
#

class Itinerary < ActiveRecord::Base
  validates :name, presence: true
  validates :user_id, presence: true
  validates :enquiry_id, presence: true
  validates :start_date, presence: true
  #validate  :start_date_cannot_be_in_the_past
  
  belongs_to    :user
  has_one       :itinerary_price
  belongs_to    :itinerary_template
  belongs_to    :enquiry

  belongs_to    :destination_image, :class_name => "ImageHolder", :foreign_key => :destination_image_id
  accepts_nested_attributes_for :destination_image
  
  has_many :itinerary_infos, -> { order("position ASC")}
  accepts_nested_attributes_for :itinerary_infos, allow_destroy: true

  has_and_belongs_to_many :customers
  accepts_nested_attributes_for :customers, allow_destroy: true
  validates_associated :customers

  belongs_to  :agent, :class_name => "Customer", :foreign_key => :agent_id
  belongs_to  :lead_customer, :class_name => "Customer", :foreign_key => :lead_customer_id
  
  after_save  :set_lead

##### START

  has_paper_trail :ignore => [:created_at, :updated_at], :meta => { :customer_names  => :customer_names}

  def is_customer_lead(customer)
    return (self.lead_customer == customer) || (customer.lead_customer == 'true')
  end
  
  def add_customer(customer)
    #self.customer_enquiries.create!(customer_id: customer.id) unless customer.nil?
    self.customers << customer unless customer.nil?
  end
 
  def set_lead
    self.customers.each do |c|
      self.update_column(:lead_customer_id, c.id) if c.lead_customer
    end
    
    if !self.lead_customer
      # if lead customer not set default to first customer
      self.update_column(:lead_customer_id, self.customers.first.id) if self.customers.first
    end
    
    # self.lead_customer ? self.update_column(:lead_customer_name, self.lead_customer.fullname) : self.update_column(:lead_customer_name, "")
  end
  
  def removeInvalidCustomerError
    
    if self.errors && self.errors.messages[:customers]
      self.errors.messages.delete(:customers)
    end
    
    if self.errors && self.errors.messages[:"customers.lead_customer"]
      self.errors.messages.delete(:"customers.lead_customer")
    end
    
  end

  def agent_name
    return self.agent.fullname if self.agent
  end

  def customer_name_and_title
    str = ""
    if self.lead_customer
      str = self.lead_customer.title + " " if self.lead_customer.title
      str = str + self.lead_customer.first_name + " " + self.lead_customer.last_name
    else
      str = "No Customer Details"
    end
  end
  
  def agent_name_and_title
    agent = self.agent
    if agent.present?
      [agent.title, agent.first_name, agent.last_name].join(' ').squish
    else
      'No Agent Details'
    end
  end
  
  def dasboard_customer_name
    self.lead_customer ? self.lead_customer.last_name + ", " + self.lead_customer.first_name : "No Customer Details"
  end
  
  def customer_names
    str = ""
    self.customers.each do |cust|
      str = str + cust.first_name + " " + cust.last_name + ", "
    end
    return str.chomp(", ")
  end
  
  def customer_title
    self.lead_customer.title! unless !self.lead_customer
  end
  
  def customer_address
    if self.agent
      self.agent.getAddressDetails
    else
      self.lead_customer.getAddressDetails if self.lead_customer
    end
  end
  
  def customer_email
    if self.agent
      self.agent.email unless self.agent.email.blank?
    else
      self.lead_customer.email if self.lead_customer
    end
  end
  
  def customer_email_link
    if self.agent
      self.agent.create_email_link unless self.agent.email.blank?
    else
      self.lead_customer.create_email_link if self.lead_customer
    end
  end
  
  def customer_phone
    if self.agent
      self.agent.phone unless self.agent.phone.blank?
    else
      self.lead_customer.phone if self.lead_customer
    end
  end
  
  def customer_mobile
    if self.agent
      self.agent.mobile unless self.agent.mobile.blank?
    else
      self.lead_customer.mobile if self.lead_customer
    end
  end
    
  def get_first_customer_num
    num = self.lead_customer.id unless self.lead_customer.nil?
  end
    
  def first_customer
    return self.lead_customer unless self.lead_customer.nil?
  end
    
  def validate_new_customer(email, mobile)
    if !email.strip == ""
      cust = Customer.find_by_email(email)
      if !cust.nil?
        errors.add(:CustomerExists, "Customer already exists with this email: #{cust.fullname}")
      end
    end
    if mobile.strip == ""
      cust = Customer.find_by_mobile(mobile)
      if !cust.nil?
        errors.add(:CustomerExists, "Customer already exists with this mobile: #{cust.fullname}")
      end
    end
  end

###### END

  def quote_sent_update_date
    self.update_attribute(:quote_sent, DateTime.now)
  end

  def cancel
    self.update_attribute(:status, 'Cancelled')
  end
  
  def start_date_cannot_be_in_the_past
    if start_date.nil?
       errors.add(:start_date, "must be entered")
    end
    if start_date.present? && start_date < Date.today
      errors.add(:start_date, "can't be in the past")
    end
  end  
    
  def isLocked?
    return self.complete 
  end
  
  def template_name
    return self.itinerary_template.name if self.itinerary_template
  end
  
  def nice_id
    self.id.to_s.rjust(6, '0')
  end
  
  def select_suppliers
    # return list of potential suppliers for dropdowns
    suppliers = []
    self.itinerary_infos.each do |info| 
      if !info.supplier.blank? && !suppliers.include?(info.supplier)  
        suppliers << info.supplier
      end
    end
    suppliers = suppliers + Setting.global_settings.suppliers
    
    return suppliers
  end    
  
  def get_itinerary_image_link
    if self.destination_image and self.destination_image.hasImage? then
      return self.destination_image.get_image_link()
    elsif self.itinerary_template and self.itinerary_template.itinerary_default_image  and self.itinerary_template.itinerary_default_image.hasImage?  then 
      return self.itinerary_template.itinerary_default_image.get_image_link()
    else
      return Setting.global_settings.get_itinerary_default_image_link()
    end
  end
  
  def get_company_logo_image_link
    if self.enquiry.agent then 
      return self.enquiry.agent.get_company_logo_image_link()
    else
      Setting.global_settings.get_company_logo_image_link()
    end 
  end
  
  def copy_template(template)
    if !template
      return
    end
    
    # populates itinerary from a template
    self.includes = template.includes.presence || Setting.global_settings.itinerary_includes
    self.excludes = template.excludes.presence || Setting.global_settings.itinerary_excludes
    self.notes = template.notes.presence || Setting.global_settings.itinerary_notes
    
    startleg = self.start_date
    itinerary_start = self.start_date
    
    template.itinerary_template_infos.each do |i|
      startleg = itinerary_start + i.days_from_start.days
      endleg = startleg + i.length.days
      
      self.add_info_from_template_info(i,startleg,endleg,i.position) if i.product
    end
  end

  
  def insert_template(template_id, pos)
    newTemplate = ItineraryTemplate.find(template_id)
    
    # find date where we are inserting. 
    if pos == 0 
      # start date will be start of itineary. 
      startleg = self.start_date
    else
      # start date will be day after insert position. 
      insertAfterInfo = self.itinerary_infos.find_by_position(pos)
      startleg = insertAfterInfo.end_date
    end
    
    # push out info position of existing infos, to allow new ones to be inserted at front.  
    # Also bump dates by total days from start on new template 
    offset = newTemplate.itinerary_template_infos.count   # get count of new template infos
    bumpDates = newTemplate.itinerary_template_infos.last.days_from_start   # should be the total number of days on template (if set up right...)
    self.itinerary_infos.each do |info|
      if info.position > pos
        info.position = info.position + offset 
        info.start_date = info.start_date + bumpDates.days
        info.end_date = info.end_date + bumpDates.days
      end 
    end

    insertPos = pos  # set start position for insert. 
    itinerary_start = startleg
      
    #insert new infos from template using new insert pos,  
    newTemplate.itinerary_template_infos.each do |i|
      insertPos = insertPos + 1
      startleg = itinerary_start + i.days_from_start.days
      endleg = startleg + i.length.days
      self.add_info_from_template_info(i,startleg,endleg,insertPos) if i.product   
    end
  end
  
  def add_info_from_template_info(info_template, startleg, endleg, pos)
    self.itinerary_infos.build(
          start_date: startleg,
          end_date: endleg,
          room_type: info_template.room_type,
          position: pos,
          supplier_id:  info_template.supplier_id,
          product_id: info_template.product_id,
          length: info_template.length,
          group_classification: info_template.group_classification,
          includes_lunch: info_template.includes_lunch,
          includes_dinner: info_template.includes_dinner,
          includes_breakfast: info_template.includes_breakfast,
          )    
  end
  
  def get_end_date
    if !self.itinerary_infos.empty?
      lastdate = self.itinerary_infos.first.end_date
      
      self.itinerary_infos.each do |info|
        lastdate = info.end_date if lastdate < info.end_date
      end
    end
    return lastdate
  end
  
  def start_date_display
    self.start_date.strftime('%d %b %Y')
  end
  def end_date_display
    self.get_end_date.strftime('%d %b %Y')
  end
  
  def get_trip_date_range
    str = self.start_date.strftime('%d %b %Y')
    if self.get_end_date
      str += " - #{self.get_end_date.strftime('%d %b %Y')}"
    end 
    return str
  end
  
  def get_infos_for_date(date)
    products = self.itinerary_infos.where("start_date <= :date AND end_date >= :date", date: date)
    return products  
  end
  
  def set_up_print_count
    @countme = self.itinerary_infos.count
  end
    
  def set_up_print
    self.start_date.upto(self.get_end_date) do |date| 
      @leg_count = @leg_count + 1 
      @infos = @itinerary.get_infos_for_date(date) 
      
      @infos.order('start_date').each do |info|    
        if info.product.type == "Hotel" 
          if info.end_date == date
              # then dont use this as locations 
          end       
        end
      end
    end
  end
end
