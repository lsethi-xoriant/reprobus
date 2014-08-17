class StaticPagesController < ApplicationController
  layout "plain"
  skip_before_filter :verify_authenticity_token
  
  def home
  end

  def about
  end
  
  def dashboard
    @user = current_user
    @assigned_enquiries = @user.assigned_enquiries.paginate(page: params[:page]).per_page(8)    
    render :layout => "application"
  end  
  
  def dashboard_list
    @user = current_user
    @assigned_enquiries = @user.assigned_enquiries.paginate(page: params[:page]).per_page(20)  
    render :layout => "application"
  end  
  
  def post
     # process various message parameters:
     sender  = params['from']
     subject = params['subject']

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
     render :text => "OK"
puts "header key: #{sender}, header value: #{subject}"
   end 
end
