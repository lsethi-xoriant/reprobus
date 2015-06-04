require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  test "login with invalid information" do
    get signin_path
    assert_template 'sessions/new'
    post sessions_path, session: { email: "", password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  test "login with valid information" do
    get signin_path
    assert_template 'sessions/new'
    post sessions_path, session: { email: "email@email1.com", password: "password" }
    assert_redirected_to dashboard_path
    
    follow_redirect!
    assert_template 'static_pages/snapshot'
    #assert user_signed_in?, "Not signed in"
  end
  
end