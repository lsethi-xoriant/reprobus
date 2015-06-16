# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#

class Country < Admin
  validates :name, presence: true, length: { maximum: 255 }
  
  has_many :destinations
  
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
      
      str = (row["country"])
      str ||= (row["Country"])
      if find_by_name(str)
        next # skip if this record exists.
      end
      
      ent = new
      ent.name = str
      
      if !ent.save
        errstr = "<br>" + "Country: #{ent.name} has validation errors - #{ent.errors.full_messages}" + errstr 
        val = val + 1
        next
      end
      int = int + 1
    end
    
    returnStr = "<strong>Country Import</strong><br>" + 
                (spreadsheet.last_row - 1).to_s + " rows read.<br>" + int.to_s + " countries created.<br>" + 
                skip.to_s + " records skipped due to record already exists<br>" + 
                val.to_s + " Validation errors:"
    return returnStr + errstr;
  end
  
end
