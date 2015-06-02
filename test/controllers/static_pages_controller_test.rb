require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase

  def setup
    @user = users(:one)
  end
  
  test "should get about" do
    get :about
    assert_response :success
  end
  
end