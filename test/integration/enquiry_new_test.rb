require 'test_helper'

class EnquiryNewTest < ActionDispatch::IntegrationTest

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
                                     user_id:    "1",
                                     assigned_to: "1",
                                     customers_attributes:{first_name: "Harold", last_name: "Johnson", email: "yoyo@yoyuo.com"}}
    end
# test not working... failing on enquiry save... will need to revisit. i think it is to do with customers through customer_enquiries.
    assert_template 'enquiries/show'
  end
  
end