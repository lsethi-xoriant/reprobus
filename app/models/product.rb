# == Schema Information
#
# Table name: products
#
#  id             :integer          not null, primary key
#  type           :string
#  name           :string
#  country        :string
#  city           :string
#  description    :text
#  price_single   :decimal(12, 2)
#  price_double   :decimal(12, 2)
#  price_tripple  :decimal(12, 2)
#  product_type   :string
#  room_type      :string
#  rating         :string
#  destination    :string
#  default_length :integer
#  supplier_id    :integer
#  created_at     :datetime
#  updated_at     :datetime
#  image          :string
#

class Product < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  
  validates :type,:name, presence: true
  validates :supplier_id,  presence: true
  

  has_many    :itinerary_infos
  has_many    :itinerary_template_infos
  belongs_to  :supplier, :class_name => "Customer", :foreign_key => :supplier_id


  def supplierName
    return self.supplier.supplier_name if self.supplier
  end
  
  def product_details
    return self.type.upcase + " | " + self.name + " | " + self.city + " | " + self.country
  end
end
