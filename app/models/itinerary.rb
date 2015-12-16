# == Schema Information
#
# Table name: itineraries
#
#  id                       :integer          not null, primary key
#  name                     :string
#  start_date               :date
#  num_passengers           :integer
#  complete                 :boolean
#  sent                     :boolean
#  quality_check            :boolean
#  includes                 :text
#  excludes                 :text
#  notes                    :text
#  flight_reference         :string
#  user_id                  :integer
#  customer_id              :integer
#  created_at               :datetime
#  updated_at               :datetime
#  itinerary_template_id    :integer
#  enquiry_id               :integer
#  status                   :string
#  destination_image_id     :integer
#  quote_sent               :datetime
#  confirmed_itinerary_sent :datetime
#  agent_id                 :integer
#  lead_customer_id         :integer
#

class Itinerary < ActiveRecord::Base
  include CustomerRelation

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

  has_paper_trail :ignore => [:created_at, :updated_at], :meta => { :customer_names  => :customer_names }

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
  
  def select_suppliers_for_pricing
    # return list of potential suppliers for dropdowns
    suppliers = []
    suppliers = suppliers + Setting.global_settings.suppliers
    
    self.itinerary_infos.each do |info| 
      if !info.supplier.blank? && !suppliers.include?(info.supplier)  
        suppliers << info.supplier
      end
    end
    
    if self.itinerary_price 
      self.itinerary_price.supplier_itinerary_price_items.each do |sipi|
        if sipi.supplier && !suppliers.include?(sipi.supplier)    
          suppliers << sipi.supplier
        end 
      end
    end 
    
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
