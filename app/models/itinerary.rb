# == Schema Information
#
# Table name: itineraries
#
#  id                    :integer          not null, primary key
#  name                  :string
#  start_date            :date
#  num_passengers        :integer
#  complete              :boolean
#  sent                  :boolean
#  quality_check         :boolean
#  price_per_person      :decimal(12, 2)
#  price_total           :decimal(12, 2)
#  bed                   :string
#  includes              :text
#  excludes              :text
#  notes                 :text
#  flight_reference      :string
#  user_id               :integer
#  customer_id           :integer
#  created_at            :datetime
#  updated_at            :datetime
#  itinerary_template_id :integer
#  enquiry_id            :integer
#  status                :string
#  end_date              :date
#

class Itinerary < ActiveRecord::Base
  validates :name, presence: true
  validates :user_id, presence: true
  validates :enquiry_id, presence: true
  validates :start_date, presence: true
  validate  :start_date_cannot_be_in_the_past
  
  belongs_to    :user
  has_one       :itinerary_price
  belongs_to    :itinerary_template
  belongs_to    :enquiry
  
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
  
  def copy_template(template)
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
  
  def insert_template(template_id, pos)
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
          offset: info_template.offset
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
  
end
