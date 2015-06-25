class DocumentUploadJob < ActiveJob::Base
  queue_as :default

  def perform(type, job_progress)
    @type = type
    @jp = job_progress
    
    #@type.constantize.importfile(type, @jp)
    Admin.importfile(@type, @jp)
    # Do something later
  end
end
