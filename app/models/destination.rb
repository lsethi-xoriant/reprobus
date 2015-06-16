# == Schema Information
#
# Table name: destinations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  country_id :integer
#  

class Destination < Admin
   validates :name, presence: true, length: { maximum: 255 }
   
   has_and_belongs_to_many :enquiries
   belongs_to :country
   
   def country_name
      self.country.name if self.country
   end
   
  require 'roo'
  
  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    int = 0
    val = 0
    returnStr = ""
    errstr = ""
    
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      
      str = (row["destination"])
      str ||= (row["Destination"])
      if find_by_name(str)
        next # skip if this record exists.
      end
      
      ent = new
      ent.name = str
      
      str = (row["country"])
      str ||= (row["Country"])     
      count =  Country.find_by_name(str)
      if count
         ent.country = count
      end
      
      if !ent.save
        errstr = "<br>" + "Destination: #{ent.supplier_name} has validation errors - #{ent.errors.full_messages}" + errstr 
        val = val + 1
        next
      end
      int = int + 1
    end
    
    returnStr = "<strong>Supplier Import</strong><br>" + 
                (spreadsheet.last_row - 1).to_s + " rows read.<br>" + int.to_s + " destinations created.<br>" + 
                skip.to_s + " records skipped due to record already exists<br>" + 
                val.to_s + " Validation errors:"
    return returnStr + errstr;
  end   
end
