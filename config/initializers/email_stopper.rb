class EmailAddressFilter
  def self.delivering_email(message)
    message.perform_deliveries = false
    
    if message.to == "hamishgardiner@gmail.com" || message.to == "hamishgardiner@hotmail.com" ||
      message.to == "stephenarnold@gmail.com" || message.to == "tim@eclipsetravel.com.au" ||
      message.to == "matt@eclipsetravel.com.au"
      
      message.perform_deliveries = true
      return
    end
    
    if message.to.include? "@eclipsetravel.com.au"
      message.perform_deliveries = true
      return
    end
      

    
    #if in dev send to developers.  ###### ALL MESSAGES TO ME WHILE BUILDING APP
#    if Rails.env.development?
      message.to = "hamishgardiner@gmail.com"
      message.perform_deliveries = true
      return
#    end
  
    # otherwise, the email should NOT be sent.
  end
end

ActionMailer::Base.register_interceptor(EmailAddressFilter)

