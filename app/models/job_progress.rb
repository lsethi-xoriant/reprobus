# == Schema Information
#
# Table name: job_progresses
#
#  id         :integer          not null, primary key
#  name       :string
#  total      :integer
#  progress   :integer
#  complete   :boolean
#  started    :boolean
#  created_at :datetime
#  updated_at :datetime
#

class JobProgress < ActiveRecord::Base
  scope :in_progress, -> { where(complete: false) }
  scope :completed, -> { where(complete: false) }
  
  mount_uploader :import_file, ImportUploader
  
  def initiate_settings(name, total)
    self.name = name
    self.started = true
    self.complete = false
    self.progress = 0
    self.total = total
    self.log = ""
  end
  
  def get_display_details
    return self.name + ": " + self.total.to_s + " total rows, " +  self.progress.to_s + " successfully imported, " + " uploaded on " + self.created_at.strftime("%Y-%m-%d")
  end
  
  def update_progress(fhelp)
    if fhelp.int % 100 == 0 
      self.progress = (fhelp.int + fhelp.skip)
      self.save
    end  
  end
end
