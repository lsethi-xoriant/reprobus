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
  #validates :supplier_id,  presence: true
  

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
  
  
  def self.import(file, type)
    require 'roo'
    
    spreadsheet = Admin.open_spreadsheet(file)
    header = spreadsheet.row(1)
    int = 0
    skip = 0
    val = 0
    returnStr = ""
    errstr = ""
    
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]

      
      if type != "Transfer" && Product.where(type: type).find_by_name(row["Name"]) 
        skip = skip + 1 # record alread exists with these details. skip it. 
        next
      end
      
      count = Country.find_by_name(row["Country"])
      dest = Destination.find_by_name(row["Destination"])
      supp = Customer.find_by_supplier_name(row["Supplier"])
          
      if type == "Transfer"
        # have special condition where only skip if name, destination, and country match (lost with same name)
        doSkip = false
        
        Transfer.where(name: row["Name"]).each do |o|
          if (o.country == count) && (o.destination == dest) && (o.supplier == supp) 
            skip = skip + 1 # record alread exists with these details. skip it. 
            doSkip = true
            break            
          end
        end
        next if doSkip
      end
      
      ent = new
      ent.type = type
      str = (row["Name"])
      ent.name = str
      str = (row["Description"])
      ent.description = str
      str = (row["Supplier"])
      supp = Customer.find_by_supplier_name(str)
      ent.supplier = supp
      str = (row["Country"])
      count = Country.find_by_name(str)
      ent.country = count
      str = (row["Destination"])
      dest = Destination.find_by_name(str)
      ent.destination = dest
        
      if !ent.save
        errstr = "<br>" + "#{type}: #{ent.name} has validation errors - #{ent.errors.full_messages}" + errstr 
        val = val + 1
        next
      end
      int = int + 1
    end
    
    returnStr = "<strong>#{type} Import</strong><br>" + 
                (spreadsheet.last_row - 1).to_s + " rows read.<br>" + int.to_s + " created.<br>" + 
                skip.to_s + " records skipped due to record already exists<br>" + 
                val.to_s + " Validation errors:"
    return returnStr + errstr;
  end   
  
end
