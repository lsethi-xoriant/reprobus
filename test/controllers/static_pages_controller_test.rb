require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase

  def setup
    @user = users(:one)
    current_user = @user
  end
  
  test "should get dashboard" do
    @user = users(:one)
    current_user = @user
    get :dashboard
    assert_response :success
  end
  
  test "should get about" do
    get :about
    assert_response :success
  end
  
end