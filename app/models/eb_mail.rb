class EbMail < ActionMailer::Base
  def forgot_password(user)
    setup_email(user)
    @subject    += '早鳥網 - 重設密碼'  
    @body[:url]  = "http://iwakela.com/main/reset_password/#{user.reset_password_code}"
  end

  def weekly_report(user)
    setup_report(user)
    @subject    += '早鳥網 - 每周起床紀錄'  
    records, average = user.records.find_week_record
    logger.debug(@body.inspect)
    @body.merge!({:records => records, :average => average})
  end

  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "iwakela@gmail.com"
    @subject     = "[早鳥網] "
    @charset     = "utf-8"
    @sent_on     = Time.now
    @body[:user] = user
  end

  def setup_report(user)
    @recipients  = "#{user.email}"
    @from        = "iwakela@gmail.com"
    @subject     = "[早鳥網] "
    @charset     = "utf-8"
    @sent_on     = Time.now
    @body[:user] = user
  end

end
