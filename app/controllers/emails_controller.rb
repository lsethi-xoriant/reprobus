class EmailsController < ApplicationController
    skip_before_filter :verify_authenticity_token
  
    
  def post
     # this method recieves a post message from a mail service provider (i.e mailgun)
     # it then uses the details from the html post, to create an activity on the customer
     # that mathchs the customer emailID that was part of the email recipient.
     # process various message parameters:
     sender  = params['from']
     subject = params['subject']
     recipient  = params['recipient']
    
     #recipient = "user@example.com"
     substring = recipient[/[^@]+/]
    
     # get the "stripped" body of the message, i.e. without
     # the quoted part
     actual_body = params["stripped-text"]

    actual_body = "Subject: #{subject}\n\n#{actual_body}"
     
    # process all attachments: - removed to get up and running
#      count = params['attachment-count'].to_i
#      count.times do |i|
#        stream = params["attachment-#{i+1}"]
#        filename = stream.original_filename
#        data = stream.read()
#      end
    
      cust = Customer.find_by(emailID: substring)
      if !cust.nil?
        cust.activities.create(type: "EmailSent", description: actual_body, user_email: sender)
      end
    
     render :text => "OK"
#puts "header key: #{sender}, header value: #{subject}, header value: #{recipient}, header value: #{substring}"
    
   end
  
end
