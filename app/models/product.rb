# == Schema Information
#
# Table name: products
#
#  id                   :integer          not null, primary key
#  type                 :string
#  name                 :string
#  description          :text
#  price_single         :decimal(12, 2)
#  price_double         :decimal(12, 2)
#  price_triple         :decimal(12, 2)
#  room_type            :string
#  rating               :string
#  destination          :string
#  default_length       :integer
#  created_at           :datetime
#  updated_at           :datetime
#  image                :string
#  country_id           :integer
#  destination_id       :integer
#  country_search       :string
#  destination_search   :string
#  remote_url           :string
#  hotel_id             :integer
#  address              :text
#  phone                :string
#  cruise_id            :integer
#  group_classification :string
#  includes_breakfast   :boolean
#  includes_lunch       :boolean
#  includes_dinner      :boolean
#

class Product < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  
  validates :type,:name, presence: true
  #validates :supplier_id,  presence: true
  
  has_many :rooms, -> { order("id ASC")}, :class_name => "Product", :foreign_key => "hotel_id"
  accepts_nested_attributes_for :rooms, allow_destroy: true; 
  belongs_to :hotel, :class_name => "Product"
  
  has_many :cruise_days, :class_name => "Product", :foreign_key => "cruise_id"
  accepts_nested_attributes_for :cruise_days, allow_destroy: true; 
  belongs_to :cruise, :class_name => "Product"
  
  has_many    :itinerary_infos
  has_many    :itinerary_template_infos
  
  #belongs_to  :supplier, :class_name => "Customer", :foreign_key => :supplier_id
  has_and_belongs_to_many :suppliers, :class_name => "Customer", :join_table => "customers_products", :association_foreign_key  => :customer_id
  
  belongs_to  :country
  belongs_to  :destination

  before_save  :set_search_terms
  after_initialize :set_defaults_on_init
  
  def set_search_terms
    self.country_search = self.country_name
    self.destination_search = self.destination_name
  end
  
  def set_defaults_on_init
    if self.type == "Hotel" && self.new_record?
      self.includes_breakfast = true
    end
  end

  def supplierNames
    names = ""
    self.suppliers.each do |sup|
      names = names + "#{sup.supplier_name}, "
    end
    return names.chomp(", ") 
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
  
  def self.handle_file_import(spreadsheet, fhelp, job_progress, type, run_live)
    # NOTE: 'Room' & 'CruiseDay' type has this method overwritten in subclass
      header = spreadsheet.row(1)
      header = header.map(&:upcase)
      
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        ent = nil
        update = false
        
        count = Country.find_by_name(row["COUNTRY"])
        dest = Destination.find_by_name(row["DESTINATION"])
        
        if row["SUPPLIER"] != ""
          supp = Customer.find_by_supplier_name(row["SUPPLIER"]) 
        else
          supp = nil
        end
        
        if type == "Transfer" 
          # have special condition where only skip if name, destination, supplier, and country match (lots with same name)
          if Transfer.includes(:suppliers).where("customers_products.customer_id" => supp).where(country_id: count).where(destination_id: dest).where(name: row["NAME"]).count > 0
            fhelp.add_skip_record("Row " + (i-1).to_s + " skipped due to existing match on: #{row["NAME"]} | #{row["COUNTRY"]} | #{row["DESTINATION"]} | #{row["SUPPLIER"]}");
            next
          end
          # if we have a transfer matching on name, country and destination, add the supplier to this one. 
          ent = Transfer.find_by name: row["NAME"], country_id: count, destination_id: dest
        elsif type == "Hotel"
          if Hotel.includes(:suppliers).where("customers_products.customer_id" => supp).where(country_id: count).where(destination_id: dest).where(name: row["NAME"]).count > 0
            fhelp.add_skip_record("Row " + (i-1).to_s + " skipped due to match on: #{row["NAME"]} | #{row["COUNTRY"]} | #{row["DESTINATION"]} | #{row["SUPPLIER"]}");
            next
          end
          # if we have a transfer matching on name, country and destination, add the supplier to this one. 
          ent = Hotel.find_by name: row["NAME"], country_id: count, destination_id: dest
        else
          if Product.includes(:suppliers).where("customers_products.customer_id" => supp).where(type: type).find_by_name(row["NAME"])
            fhelp.add_skip_record("Row " + (i-1).to_s + " skipped due to existing match on: #{row["NAME"]}")
            next
          end
          ent = Product.find_by name: row["NAME"]
        end
        
        if ent
          # we matched to existing record, it can be updated. 
          fhelp.add_update_record("Row " + (i-1).to_s + " record updated to existing match on: #{row["NAME"]}")
          update = true
        else
          ent = new
        end
        
        ent.type = type
        str = (row["NAME"])
        ent.name = str
        str = (row["DESCRIPTION"])
        ent.description = str
        str = (row["IMAGENAME"])
        ent.remote_url = str
  
        ent.suppliers << supp if supp
        ent.country = count
        ent.destination = dest
        
        if type == "Hotel"
          ent.address = (row["ADDRESS"])
          ent.phone = (row["PHONE"])
          ent.rating  = (row["RATING"])
        end  
          
        if (run_live && !ent.save) || (!run_live && !ent.valid?)
          fhelp.add_validation_record("Row " + (i-1).to_s + " : #{type}: #{ent.name} has validation errors - #{ent.errors.full_messages}")
          next
        end
        
        fhelp.int = fhelp.int + 1 if !update
        job_progress.update_progress(fhelp)
      end
      
    return fhelp;
  end
  
end
