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
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      ent = find_by_id(row["ID"]) || new
      str = (row["country"])
      str ||= (row["Country"])
      if find_by_name(str)
        next
      end
      ent.name = str
      ent.save!
      int = int + 1
    end
    returnStr = (spreadsheet.last_row - 1).to_s + " rows read. " + int.to_s + " countries created"
    return returnStr;
  end
  
end
