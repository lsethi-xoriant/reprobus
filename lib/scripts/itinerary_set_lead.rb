Iinearary.all.each do |i| 
  if i.enquiry then 
    i.lead_customer = i.enquiry.lead_customer
    i.save
  end
  
end