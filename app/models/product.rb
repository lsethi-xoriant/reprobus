# == Schema Information
#
# Table name: products
#
#  id                 :integer          not null, primary key
#  type               :string
#  name               :string
#  description        :text
#  price_single       :decimal(12, 2)
#  price_double       :decimal(12, 2)
#  price_tripple      :decimal(12, 2)
#  product_type       :string
#  room_type          :string
#  rating             :string
#  destination        :string
#  default_length     :integer
#  supplier_id        :integer
#  created_at         :datetime
#  updated_at         :datetime
#  image              :string
#  country_id         :integer
#  destination_id     :integer
#  country_search     :string
#  destination_search :string
#

class Product < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  
  validates :type,:name, presence: true
  validates :supplier_id,  presence: true
  

  has_many    :itinerary_infos
  has_many    :itinerary_template_infos
  belongs_to  :supplier, :class_name => "Customer", :foreign_key => :supplier_id
  belongs_to  :country
  belongs_to  :destination

  before_save  :set_search_terms

  def set_search_terms
    self.country_search = self.country_name
    self.destination_search = self.destination_name
  end

  def supplierName
    return self.supplier.supplier_name if self.supplier
  end
  
  def product_details
    return self.type.upcase + " | " + self.name + " | " + self.destination_name + " | " + self.country_name
  end
  
  def country_name
    return self.country.name if self.country
  end
  
  def destination_name
    return self.destination.name if self.destination
  end
end
