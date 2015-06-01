require 'test_helper'
require 'sessions_helper'

class EnquiriesControllerTest < ActionController::TestCase

  test "should get new" do
    get :new
    assert_response :success
  end
  
  
end