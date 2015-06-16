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
    returnStr = ""
    
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      ent = find_by_id(row["ID"]) || find_by_id(row["Id"]) || new
      
      str = (row["destination"])
      str ||= (row["Destination"])
      
      ent.name = str
      
      str = (row["country"])
      str ||= (row["Country"])     
      count =  Country.find_by_name(str)
      if count
         ent.country = count
      end
      
      ent.save!
      int = int + 1
    end
    returnStr = (spreadsheet.last_row - 1).to_s + " rows read. " + int.to_s + " countries created"
    return returnStr;
  end   
end
