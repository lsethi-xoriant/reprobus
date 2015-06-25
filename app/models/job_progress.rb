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
  
  def initiate_settings(name, total)
    self.name = name
    self.started = true
    self.complete = false
    self.progress = 0
    self.total = total
    self.log = ""
  end
  
  def get_display_details
    return self.name + " - total rows : " + self.total.to_s + ", successfully imported : " + self.progress.to_s + ", uploaded on " + self.created_at.strftime("%Y-%m-%d")
  end
end
