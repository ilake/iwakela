class EbMail < ActionMailer::Base
  def confirm_email(user)
    setup_email(user)
    @subject    += '早鳥網'  
    @body[:url]  = "http://#{EB_HOST}/main/confirm_email/#{user.about_state.confirm_email_code}"
  end

  def forgot_password(user)
    setup_email(user)
    @subject    += '早鳥網 - 重設密碼'  
    @body[:url]  = "http://#{EB_HOST}/main/reset_password/#{user.reset_password_code}"
  end

  def weekly_report(user)
    setup_report(user)
    @subject    += '早鳥網 - 每周起床紀錄'  
    records, average = user.records.find_week_record
    logger.debug(@body.inspect)
    @body.merge!({:records => records, :average => average})
  end

  def message_response(msg)
    if msg.message_id
      #這是主人回應, 寄給留言者
      be_reminder = msg.parent_msg.user
      msg_owner =  msg.owner.id
      msg_id = msg.parent_msg.id
    else
      #這是新留言, 寄給主人
      be_reminder = msg.owner
      msg_owner = msg.owner.id
      msg_id = msg.id
    end
    @recipients  = "#{be_reminder.email}"
    @from        = "iwakela@gmail.com"
    @subject     = "[早鳥網] 有新留言"
    @charset     = "utf-8"
    @sent_on     = Time.now
    @body[:user] = be_reminder
    @body[:url]  = "http://#{EB_HOST}/messages/show?id=#{msg_owner}&message_id=#{msg_id}"
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
