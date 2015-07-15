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
  validates :start_date, presence: true
  
  belongs_to    :user
  has_one       :itinerary_price
  belongs_to    :itinerary_template
  belongs_to    :enquiry
  
  has_many :itinerary_infos, -> { order("position ASC")}
  accepts_nested_attributes_for :itinerary_infos
  
  def template_name
    return self.itinerary_template.name if self.itinerary_template
  end
  
  def copy_template(template)
    if !template
      return
    end
    
    # populates itinerary from a template - WARNING - destroys old intinrary infos...
    
    self.includes = template.includes
    self.excludes = template.excludes
    self.notes = template.notes
    
    self.itinerary_infos.destroy_all
    
    startleg = self.start_date
    
    template.itinerary_template_infos.each do |i|
      endleg = startleg + i.length.days
      
    self.itinerary_infos.build(
                            name: i.product.name,
                            start_date: startleg,
                            end_date: endleg,
                            country: i.product.country_name,
                            city: i.product.destination_name,
                            product_name: i.product.name,
                            product_description: i.product.description,
                            product_price: i.product.price_single,
                            rating: i.product.rating,
                            room_type: i.product.room_type,
                            position: i.position,
                            supplier_id:  i.supplier_id,
                            product_id: i.product_id,
                            length: i.length)
                            

      startleg = endleg
    end
  end
  
end
