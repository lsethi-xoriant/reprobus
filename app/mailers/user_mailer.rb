class UserMailer < ActionMailer::Base
  default from: "supperapp@tripease.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    if !Setting.global_settings.send_emails_turned_off
      mail :to => user.email, :subject => "Password Reset", from: "donotreply@superapp.com"
    end 
  end
  
 
  def welcome_email(user)
    @user = user
    if !Setting.global_settings.send_emails_turned_off
      mail(to: @user.email, subject: "Welcome!", from: "donotreply@superapp.com")
    end
  end
end
