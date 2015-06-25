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


  def self.import_job(file, type)
    job_progress = JobProgress.new
    job_progress.import_file = file
    job_progress.initiate_settings(type + " Import", 0)
    job_progress.save
    
    DocumentUploadJob.perform_later(type, job_progress)
  end
  
  def self.import(file)
    # standard import from admin screen
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


  def self.importfile(type, job_progress)
    # background import from import
    spreadsheet = open_spreadsheet_from_job(job_progress)
    
    fhelp = FileLoadHelper.new
    fhelp.setdefaults

    job_progress.initiate_settings(type + " Import"  ,spreadsheet.last_row)
    job_progress.save    
    
    type.constantize.handle_file_import(spreadsheet, fhelp, job_progress, type)
    
    fhelp.returnStr = "<strong>#{type} Import</strong><br>" +
                      (spreadsheet.last_row - 1).to_s + " rows read.<br>" + fhelp.int.to_s + " created.<br>" +
                      fhelp.skip.to_s + " records skipped due to record already exists<br>" +
                      fhelp.val.to_s + " Validation errors"
                
    job_progress.summary = fhelp.returnStr
    job_progress.log = "Validation errors:" + fhelp.errstr + "<br><br> Items Skipped:<br>" + fhelp.skipstr
    job_progress.complete = true
    
    job_progress.remove_import_file! #delete file now we have uploaded it. 
    job_progress.save
  end
  
  def self.handle_file_import(spreadsheet, fhelp, job_progress, type)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      ent = find_by_id(row["id"]) || new
      str = (row["name"])
      str ||= (row["Name"])
      ent.name = str
      ent.save!
      fhelp.int = fhelp.int + 1
      job_progress.update_progress(fhelp)    
    end
  end
  
  # used in file load from admin screen - no background process 
  def self.open_spreadsheet(file)
#    puts file.path  
  case File.extname(file.original_filename)
  when ".csv" then Roo::CSV.new(file.path)
  when ".xls" then Roo::Excel.new(file.path, file_warning: :ignore)
  when ".xlsx" then Roo::Excelx.new(file.path, file_warning: :ignore)
  else raise "Unknown file type: #{file.original_filename}"
  end
  end

# used in file load from import screen - background process
  def self.open_spreadsheet_from_job(job_progress)
    case File.extname(job_progress.import_file.current_path)
      when ".csv" then Roo::Spreadsheet.open(job_progress.import_file.url, extension: :csv) 
      when ".xls" then Roo::Spreadsheet.open(job_progress.import_file.url, extension: :xls)
      when ".xlsx" then Roo::Spreadsheet.open(job_progress.import_file.url, extension: :xlsx)
      else raise "Unknown file type: #{job_progress.import_file.url}"
    end
  end
  
end