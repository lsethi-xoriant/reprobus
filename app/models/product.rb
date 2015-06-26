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
#  remote_url         :string
#  hotel_id           :integer
#  address            :text
#  phone              :string
#

class Product < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  
  validates :type,:name, presence: true
  #validates :supplier_id,  presence: true
  
  has_many :hotel_rooms, :class_name => "Product", :foreign_key => "hotel_id"
  accepts_nested_attributes_for :hotel_rooms, allow_destroy: true; 
  belongs_to :hotel, :class_name => "Product"
  
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
    return "#{self.type.upcase} | #{self.name} | #{self.destination_name} | #{self.country_name}"
  end
  
  def country_name
    return self.country.name if self.country
  end
  
  def destination_name
    return self.destination.name if self.destination
  end
  
  def get_dropbox_image_link
    if !self.remote_url.blank?
      return DropboxHelper.get_db_image_link_url(self.remote_url)
    else
      return ActionController::Base.helpers.image_path('noImage.jpg')
    end
  end
  
  def self.handle_file_import(spreadsheet, fhelp, job_progress, type)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
  
        if type != "Transfer" && Product.where(type: type).find_by_name(row["Name"])
          fhelp.add_skip_record("Row " + (i-1).to_s + " skipped due to matches on: #{row["Name"]}")
          next
        end
        
        count = Country.find_by_name(row["Country"])
        dest = Destination.find_by_name(row["Destination"])
        supp = Customer.find_by_supplier_name(row["Supplier"])
            
        if type == "Transfer"
          # have special condition where only skip if name, destination, supplier, and country match (lots with same name)
          if Transfer.where(supplier_id: supp).where(country_id: count).where(destination_id: dest).where(name: row["Name"]).count > 0
            fhelp.add_skip_record("Row " + (i-1).to_s + " skipped due to matches on: #{row["Name"]} | #{row["Country"]} | #{row["Destination"]} | #{row["Supplier"]}");
            next
          end
        end
        
        ent = new
        ent.type = type
        str = (row["Name"])
        ent.name = str
        str = (row["Description"])
        ent.description = str
        str = (row["ImageName"])
        ent.remote_url = str
  
        ent.supplier = supp
        ent.country = count
        ent.destination = dest
          
        if !ent.save
          fhelp.add_validation_record("#{type}: #{ent.name} has validation errors - #{ent.errors.full_messages}")
          next
        end
        
        fhelp.int = fhelp.int + 1
        job_progress.update_progress(fhelp)
      end
      
    return fhelp;
  end
  
end
