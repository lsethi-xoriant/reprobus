require 'test_helper'

class PasswordResetTest < ActionDispatch::IntegrationTest
 def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:one)
  end
  
  
  test "invalid new enquiry information" do
    log_in_default
    
    get new_enquiry_path
    assert_no_difference 'Enquiry.count' do
      post enquiries_path, enquiry: { name:  "",
                               stage: "New Enquiry",
                               user_id:              "1" }
    end
    assert_template 'enquiries/new'
  end
  
  test "valid new enquiry information" do
    log_in_default
    
    get new_enquiry_path
    assert_difference 'Enquiry.count', 1 do
      post enquiries_path, enquiry: { name:  "New Enq",
                                 stage: "New Enquiry",
                                 user_id:              "1" }
    end

    assert_template 'enquiries/show'
  end
  
end