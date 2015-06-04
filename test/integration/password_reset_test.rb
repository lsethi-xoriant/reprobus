require 'test_helper'

class PasswordResetTest < ActionDispatch::IntegrationTest
 def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:one)
  end
  
  
  test "password resets" do
    get password_resets_new_path
    assert_template 'password_resets/new'
    # Invalid email
    post password_resets_path( email: "" )
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Valid email
    post password_resets_path(email: @user.email)
    assert_not_equal @user.password_reset_token, @user.reload.password_reset_token
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Password reset form
    user = @user
    # Right email, wrong token
    get edit_password_reset_path('wrong token')
    assert_redirected_to root_url
    # Right email, right token
    get edit_password_reset_path(user.password_reset_token)
    assert_template 'password_resets/edit'
    # Invalid password & confirmation
    patch password_reset_path(user.password_reset_token),
          user: { password:              "foobaz",
                  password_confirmation: "barquux" }
    assert_select 'div#error_explanation'
    # Empty password
    patch password_reset_path(user.password_reset_token),
          user: { password:  "",
                  password_confirmation: "" }
    assert_not flash.empty?
    assert_template 'password_resets/edit'
    # Valid password & confirmation
    patch password_reset_path(user.password_reset_token),
          email: user.email,
          user: { password:              "foobaz",
                  password_confirmation: "foobaz" }
    assert_not flash.empty?
    assert_redirected_to signin_path
  end
  
end