class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset", from: "donotreply@superapp.com"
  end
  
 
  def welcome_email(user)
    @user = user
    mail(to: @user.email_address, subject: "Welcome!", from: "donotreply@superapp.com")
  end  
end
