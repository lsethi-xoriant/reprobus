Customer.all.each do |c| 
  if c.email == "tim@eclipsetravel.com.au" then 
puts "found tim1"    
    c.email = "tim@eclipsotravel.com.au"
    c.save
  end

  if c.email == "enquiry@eclipsetravel.com.au" then 
puts "found tim2"    
    c.email = "timmm@eclipsotravel.com.au"
    c.save
  end
  
  if c.email == "timbho@gmail.com.au" then 
puts "found tim3"    
    c.email = "timmmmmm@eclipsotravel.com.au"
    c.save
  end
  
  
  if c.email == "accounts@eclipsetravel.com.au" then 
puts "found tim4"    
    c.email = "timmmmmmmm@eclipsotravel.com.au"
    c.save
  end

end