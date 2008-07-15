class UserNotifier < ActionMailer::Base
  def forgot_password(user)
    setup_email(user)
    @subject    += 'MySpyder.net - Reset Password'  
    @body[:url]  = "http://iwakela.com/reset_password/#{user.reset_password_code}"
  end

  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "iwakela@gmail.com"
    @subject     = "[早鳥網] "
    @sent_on     = Time.now
    @body[:user] = user
  end
end
