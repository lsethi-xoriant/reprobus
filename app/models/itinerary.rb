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
#  price_per_person           :decimal(12, 2)
#  price_total                :decimal(12, 2)
#  bed                        :string
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
  belongs_to  :itinerary_default_image, :class_name => "ImageHolder", :foreign_key => :itinerary_default_image_id
  accepts_nested_attributes_for :itinerary_default_image, allow_destroy: true

  
  has_many :itinerary_infos, -> { order("position ASC")}
  accepts_nested_attributes_for :itinerary_infos, allow_destroy: true
  
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
  
  def get_itinerary_image_link
    if self.itinerary_default_image and self.itinerary_default_image.hasImage? then 
      return self.itinerary_default_image.get_image_link()
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
          name: info_template.product.name,
          start_date: startleg,
          end_date: endleg,
          country: info_template.product.country_name,
          city: info_template.product.destination_name,
          product_name: info_template.product.name,
          product_description: info_template.product.description,
          product_price: info_template.product.price_single,
          rating: info_template.product.rating,
          room_type: info_template.product.room_type,
          position: pos,
          supplier_id:  info_template.supplier_id,
          product_id: info_template.product_id,
          length: info_template.length,
          offset: info_template.offset,
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
  
  
  
  
  
  
  #OLD CODE BELOW - keepeing for a wee while to see if i might reuse some of it. 
  def copy_templateOLD(template)
    if !template
      return
    end
    
    # populates itinerary from a template
    self.includes = template.includes
    self.excludes = template.excludes
    self.notes = template.notes
    
    startleg = self.start_date
    latestDate = self.start_date
    
    template.itinerary_template_infos.each do |i|
      if startleg > latestDate
        latestDate = startleg  
      end
      
      # set start date
      if i.offset.abs == 0 
        startleg = latestDate
      else
        startleg = latestDate - i.offset
      end
      
      # set end date
      endleg = startleg + i.length.days
      
      self.add_info_from_template_info(i,startleg,endleg,i.position) if i.product
      startleg = endleg
    end
  end  
  
  def insert_templateOLD(template_id, pos)
    newTemplate = ItineraryTemplate.find(template_id)
    int = 0;
    offset = 0;
    startleg = self.start_date
    current_infos = self.itinerary_infos

    # push out info position to allow new ones to be inserted at front. 
    offset = newTemplate.itinerary_template_infos.count
    current_infos.each do |info|
      if info.position > pos
        info.position = info.position + offset   # is past insert, so bump position
      else
        startleg = info.start_date    # update this as we iterate through to find latest date prior to insert pos 
#        info.save
      end
    end

    # set insert pos
    int = pos #this can be set to anything starting from zero.
      
    #insert new infos from template infos from pos,  
    newTemplate.itinerary_template_infos.each do |i|
      int = int + 1
      endleg = startleg + i.length.days
      info = self.add_info_from_template_info(i,startleg,endleg,int) if i.product
      startleg = endleg  
      info.save
    end

    # now wizz through all infos, update pos and dates to make sure all correct. 
    int = 0
    startleg = self.start_date
    latestDate = self.start_date
    
    self.itinerary_infos.order("position ASC").each do |info|
      if startleg > latestDate
        latestDate = startleg  
      end
      
      # set start date
      if info.offset.abs == 0 
        startleg = latestDate
      else
        startleg = latestDate - info.offset
      end
      
      # set end date
      endleg = startleg + info.length.days
      
      int = int + 1
      # update attributes
      info.position = int
      info.start_date = startleg
      info.end_date = endleg     
      
      startleg = endleg  
    end
  end  
end
