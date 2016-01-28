Enquiry.all.each do |e|
  if e.stage == "Open"
    e.stage = "In Progress"
    e.save
  end
  
  if e.stage == "Itinerary"
    e.stage = "Quote"
    e.save
  end
end

Itinerary.all.each do |e|
  if e.status == "Pricing Created"
    e.status = "In Progress"
    e.save
  end
  if e.status == "New Itinerary"
    e.status = "In Progress"
    e.save
  end  
  if e.status == "Itinerary"
    e.status = "In Progress"
    e.save
  end    
end
