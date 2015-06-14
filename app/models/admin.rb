class Admin < ActiveRecord::Base
  require 'roo'
  #require 'spreadsheet'

  self.abstract_class = true
  
  def self.to_csv
    CSV.generate do |csv|
      csv << ["id","name",'created_at']
      all.each do |ent|
        a = Array.new
        a << ent.id << ent.name << ent.created_at
        csv << a
      end
    end
  end
  
#   def self.import(file)
#     if !file.nil? then
#       CSV.foreach(file.path, headers: true) do |row|
#         ent = find_by_id(row["id"]) || new
#         str = (row["name"])
#         str ||= (row["Name"])
#         ent.name = str
#         ent.save!
#       end
#     end
#   end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      ent = find_by_id(row["id"]) || new
      str = (row["name"])
      str ||= (row["Name"])
      ent.name = str
      ent.save!
    end
  end

  def self.open_spreadsheet(file)
#    puts file.path
  case File.extname(file.original_filename)
  when ".csv" then Roo::CSV.new(file.path)
  when ".xls" then Roo::Excel.new(file.path, file_warning: :ignore)
  when ".xlsx" then Roo::Excelx.new(file.path, file_warning: :ignore)
  else raise "Unknown file type: #{file.original_filename}"
  end
  end
    
end