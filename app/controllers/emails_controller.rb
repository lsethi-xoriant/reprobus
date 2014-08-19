class EmailsController < ApplicationController
    skip_before_filter :verify_authenticity_token
  
    
  def post
     # process various message parameters:
     sender  = params['from']
     subject = params['subject']
     recipient  = params['recipient']
    
     #recipient = "user@example.com"
     substring = recipient[/[^@]+/]
    
     # get the "stripped" body of the message, i.e. without
     # the quoted part
     actual_body = params["stripped-text"]

    # process all attachments: - removed to get up and running
#      count = params['attachment-count'].to_i
#      count.times do |i|
#        stream = params["attachment-#{i+1}"]
#        filename = stream.original_filename
#        data = stream.read()
#      end
    
      er = EmailReceiver.find_by(uniqueID: substring)
      cust = er.customer
      cust.activities.create(type: "Email", description: actual_body)
    
     render :text => "OK"
puts "header key: #{sender}, header value: #{subject}, header value: #{recipient} 
, header value: #{substring}"
   end 
  
end
