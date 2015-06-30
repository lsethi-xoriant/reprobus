class DocumentUploadJob < ActiveJob::Base
  queue_as :default

  def perform(type, job_progress, run_live)
    @type = type
    @jp = job_progress

    Admin.importfile(@type, @jp, run_live)
    # Do something later
  end
end
