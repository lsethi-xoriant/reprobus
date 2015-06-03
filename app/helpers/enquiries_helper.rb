module EnquiriesHelper
  def get_status_color(status)
    if status == 'New Enquiry'
      return "task-cat pink accent-2"
    elsif status == 'Open'
      return "task-cat orange accent-2"
    elsif status == 'In Progress'
      return "task-cat indigo darken-4"
    elsif status == 'Booking'
      return "task-cat indigo darken-4"
    end
  end
end
