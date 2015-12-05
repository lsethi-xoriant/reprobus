# == Schema Information
#
# Table name: destinations
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  country_id       :integer
#  default_image_id :integer
#

class Destination < Admin
  validates :name, presence: true, length: { maximum: 255 }
   
  has_and_belongs_to_many :enquiries
  belongs_to :country

  belongs_to :default_image, :class_name => "ImageHolder", :foreign_key => :default_image_id
  accepts_nested_attributes_for :default_image, allow_destroy: true
   
  def country_name
    self.country.name if self.country
  end
  
  
  def self.handle_file_import(spreadsheet, fhelp, job_progress, type, run_live)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      
      str = (row["destination"])
      str ||= (row["Destination"])
      if find_by_name(str)
        fhelp.add_skip_record("Row " + (i-1).to_s + " skipped due to matches on: #{str}")
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
      
      if (run_live && !ent.save) || (!run_live && !ent.valid?)
        fhelp.add_validation_record("Destination: #{ent.supplier_name} has validation errors - #{ent.errors.full_messages}")
        next
      end
        fhelp.int = fhelp.int + 1
        job_progress.update_progress(fhelp)
    end
    
    return fhelp;
  end   
  
end
