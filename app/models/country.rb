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
  
  def self.handle_file_import(spreadsheet, fhelp, job_progress, type, run_live)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      
      str = (row["country"])
      str ||= (row["Country"])
      if find_by_name(str)
        fhelp.add_skip_record("Row " + (i-1).to_s + " skipped due to matches on: #{str}")
        next # skip if this record exists.
      end
      
      ent = new
      ent.name = str
      
      
      if (run_live && !ent.save) || (!run_live && !ent.valid?)
        fhelp.add_validation_record("Country: #{ent.name} has validation errors - #{ent.errors.full_messages}")
        next
      end
      fhelp.int = fhelp.int + 1
      job_progress.update_progress(fhelp)
    end

    return fhelp;
  end
  
end
