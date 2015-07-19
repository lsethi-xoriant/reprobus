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
    
    template.itinerary_template_infos.each do |i|
      endleg = startleg + i.length.days
      self.add_info_from_template_info(i,startleg,endleg,i.position)
      startleg = endleg
    end
  end
  
  def insert_template(template_id, position)
    newTemplate = ItineraryTemplate.find(template_id)
    int = 0;
    startleg = self.start_date
    
    if position == 0 
      #if inserting at start, insert new template infos, update existing infos, then return 
      newTemplate.itinerary_template_infos.each do |i|
        int = int + 1
        endleg = startleg + i.length.days
        self.add_info_from_template_info(i,startleg,endleg,int)
        startleg = endleg      
      end
      
      self.itinerary_infos.each do |info|
        # now upate all existing infos pos and dates
        startleg = info.start_date
        endleg = startleg + info.length.days
        int = int + 1
        # update attributes
        info.position = int
        info.start_date = startleg
        info.end_date = endleg     
      end
    else
      # position over 0 so must be inserting in middle, iterate through current infos, 
      # insert new template and then update remaining infos.  
      self.itinerary_infos.each do |info|
        startleg = info.start_date
        endleg = startleg + info.length.days
        int = int + 1
        
        if position == int 
          # if we are at insert position add new itineary infos. 
          newTemplate.itinerary_template_infos.each do |i|
            int = int + 1
            endleg = startleg + i.length.days
            self.add_info_from_template_info(i,startleg,endleg,int)
            startleg = endleg
          end
        end
        
        if position > int 
            # above template will have been inserted, now we can update 
            # remaining infos positions and dates etc 
            info.position = int
            info.start_date = startleg
            info.end_date = endleg
        end
      end
      
    end
  end
  
  def add_info_from_template_info(info_template, startleg, endleg, position)
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
          position: position,
          supplier_id:  info_template.supplier_id,
          product_id: info_template.product_id,
          length: info_template.length
          )    
  end
end
