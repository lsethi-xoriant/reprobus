module EnquiriesHelper
  def get_status_color(status)
    if status == 'New Enquiry' || status == 'New Itinerary'
      return "task-cat pink accent-2"
    elsif status == 'Open'
      return "task-cat orange accent-2"
    elsif status == 'In Progress'
      return "task-cat indigo darken-4"
    elsif status == 'Booking'
      return "task-cat indigo darken-4"
    else
      return ""
    end
  end
  
  def get_date_status_color(datetime)
    if datetime <= 4.week.ago
      return "task-cat red accent-4"
    elsif datetime <= 2.week.ago
      return "task-cat orange darken-4"
    elsif datetime <= 7.day.ago
      return "task-cat amber lighten-1"
    else
      return "task-cat green"
    end
  end
end
