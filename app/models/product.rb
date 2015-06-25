# == Schema Information
#
# Table name: products
#
#  id                 :integer          not null, primary key
#  type               :string
#  name               :string
#  country_search     :string
#  destination_search :string
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
#  remote_url         :string
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
  
  def get_dropbox_image_link
    if !self.remote_url.blank?
      return DropboxHelper.get_db_image_link_url(self.remote_url)
    else
      return ActionController::Base.helpers.image_path('noImage.jpg')
    end
  end
  
  def self.import(file, type)
    file_path_to_save = 'public/uploads/imports'
    File.open(File.join(file_path_to_save,file.original_filename), "wb") { |f| f.write(file.read) }
    
    job_progress = JobProgress.new
    job_progress.initiate_settings(type + " Import", 0)
    job_progress.file_name = file.original_filename
    job_progress.file_path = file_path_to_save
    job_progress.save
    
    DocumentUploadJob.perform_later(type, job_progress)
  end

  def self.importfile(type, job_progress)
    require 'roo'
    filename = File.join(job_progress.file_path, job_progress.file_name)
    #file = File.open(filename,'r')
    
    spreadsheet = Admin.open_spreadsheet_from_path(filename)
    header = spreadsheet.row(1)
    int = 0
    skip = 0
    val = 0
    returnStr = ""
    errstr = ""
    skipstr = ""

    job_progress.initiate_settings(type + " Import"  ,spreadsheet.last_row)
    job_progress.save
    
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]

      
      if type != "Transfer" && Product.where(type: type).find_by_name(row["Name"])
        skip = skip + 1 # record alread exists with these details. skip it.
        skipstr = skipstr + "<br>Row " + (i-1).to_s + " skipped due to matches on: #{row["Name"]}"
        next
      end
      
      count = Country.find_by_name(row["Country"])
      dest = Destination.find_by_name(row["Destination"])
      supp = Customer.find_by_supplier_name(row["Supplier"])
          
      if type == "Transfer"
        # have special condition where only skip if name, destination, supplier, and country match (lots with same name)
        if Transfer.where(supplier_id: supp).where(country_id: count).where(destination_id: dest).where(name: row["Name"]).count > 0
          skip = skip + 1 # record alread exists with these details. skip it.
          skipstr = skipstr + "<br>Row " + (i-1).to_s + " skipped due to matches on: #{row["Name"]} | #{row["Country"]} | #{row["Destination"]} | #{row["Supplier"]}"
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
        errstr = "<br>" + "#{type}: #{ent.name} has validation errors - #{ent.errors.full_messages}" + errstr
        val = val + 1
        next
      end
      int = int + 1
      
      if int % 100 == 0 
        job_progress.progress = (int + skip)
        job_progress.save
      end
    end
 
    returnStr = "<strong>#{type} Import</strong><br>" +
                (spreadsheet.last_row - 1).to_s + " rows read.<br>" + int.to_s + " created.<br>" +
                skip.to_s + " records skipped due to record already exists<br>" +
                val.to_s + " Validation errors"
                
    job_progress.summary = returnStr
    job_progress.log = "Validation errors:" + errstr + "<br><br> Items Skipped:<br>" + skipstr
    job_progress.complete = true
    job_progress.save
        
    File.delete(filename)
    return returnStr + errstr;
  end
  
end
