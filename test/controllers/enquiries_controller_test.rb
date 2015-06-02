require 'test_helper'
require 'sessions_helper'

class EnquiriesControllerTest < ActionController::TestCase
  
  def setup
    @enquiry = enquiries(:firstenq)
  end
  
  test "should redirect new" do
    get :new
    assert_response :redirect
  end
  

end